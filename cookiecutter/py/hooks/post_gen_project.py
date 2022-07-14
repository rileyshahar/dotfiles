"""Set up poetry and git/github."""

import os

PROJECT_NAME = "{{ cookiecutter.name }}"

if __name__ == "__main__":
    os.system("poetryup --latest")
    os.system("poetry install")
    os.system("git init")
    os.system(
        "gh repo create {{ cookiecutter.name }} "
        "-d '{{ cookiecutter.description }}'    "
        "--public                               "
        "--source=.                             "
    )
