"""Generate query directories."""
import click
import os
from dataclasses import dataclass
from pathlib import Path
from typing import List, Optional

import yaml
from jinja2 import Environment, FileSystemLoader

from bigquery_etl.format_sql.formatter import reformat
from bigquery_etl.cli.utils import is_valid_project

TEMPLATED_FILES = {
    "init.sql",
    "metadata.yaml",
    "query.sql",
    "stored_procedure.sql",
    "udf.sql",
    "view.sql",
}


ALLOWED_FILES = TEMPLATED_FILES | {"templating.yaml"}


FILE_PATH = os.path.dirname(__file__)
BASE_DIR = Path(FILE_PATH).parent.parent


@dataclass
class Template:
    """A template, to be filled with args and saved as a file."""

    name: str
    env: Environment

    def render(self, write_path, args):
        """Render this template at the specified write_path with the specified args."""
        fpath = write_path / self.name
        print(f"...Generating {str(fpath)}")

        write_path.mkdir(parents=True, exist_ok=True)

        if "header" not in args:
            args[
                "header"
            ] = "Generated by ./bqetl generate events_daily"

        text = self._get_comment_char(fpath.suffix) + args["header"] + "\n\n"
        text += self.env.get_template(self.name).render(**args)

        if fpath.suffix == ".sql":
            text = reformat(text, trailing_newline=True)

        (write_path / self.name).write_text(text)

    def _get_comment_char(self, suffix, append=" "):
        comment_chars = {
            "sql": "--",
            "yaml": "#",
            "yml": "#",
        }

        return comment_chars[suffix[1:]] + append


@dataclass
class TemplatedDir:
    """A directory of templates, which will be rendered per the templating.yaml."""

    name: str
    path: Path
    env: Optional[Environment] = None

    def generate(self, write_path, dataset=None):
        """Render this TemplatedDir to write_path for the specified dataset."""
        args = self.get_args()
        datasets = self.get_datasets(args, dataset)

        for template in self.get_templates():
            for _dataset in datasets:
                template.render(write_path / _dataset / self.name, args[_dataset])

    def get_datasets(self, args, dataset=None) -> List[str]:
        """Get datasets to process."""
        datasets = list(args.keys())
        if dataset is not None:
            datasets = [d for d in datasets if d == dataset]
        if not datasets:
            raise Exception("Nothing to generate, no datasets found for " + self.name)
        return datasets

    def get_templates(self) -> List[Template]:
        """Get the names of the templates to process."""
        env = self.get_environment()
        return [
            Template(f.name, env)
            for f in self.path.glob("*")
            if str(f.name) in TEMPLATED_FILES
        ]

    def get_environment(self) -> Environment:
        """Get the environment."""
        if self.env is None:
            self.env = Environment(loader=FileSystemLoader(str(self.path)))
        return self.env

    def get_args(self) -> dict:
        """Get all arguments for templating, per-dataset."""
        with open(self.path / "templating.yaml", "r") as f:
            return yaml.safe_load(f) or {}


def get_query_dirs(path):
    """Walk a path to get all templated query dirs."""
    for directory, sub_dirs, files in os.walk(path):
        non_hidden = {f for f in files if not f.startswith(".")}
        if non_hidden and non_hidden.issubset(ALLOWED_FILES):
            dir_path = Path(directory)
            yield TemplatedDir(dir_path.name, dir_path)

@click.command()
@click.option(
    "--project-id",
    "--project_id",
    help="GCP project ID",
    default="moz-fx-data-shared-prod",
    callback=is_valid_project,
)
@click.option(
    "--path",
    help="Where query directories will be searched for",
    default="sql_generators/events_daily/templates",
)
@click.option(
    "--dataset",
    help="The dataset to run this for. "
    "If none selected, runs on all in the configuration yaml file.",
    default=None,
)
@click.option(
    "--output-dir",
    "--output_dir",
    help="Output directory generated SQL is written to",
    type=click.Path(file_okay=False),
    default="sql",
)
def generate(project_id, path, dataset, output_dir):
    """Generate queries at the path for project."""
    write_path = Path(output_dir) / project_id
    for query_dir in get_query_dirs(path):
        query_dir.generate(write_path, dataset)
