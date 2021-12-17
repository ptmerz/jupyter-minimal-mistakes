# jupyter-minimal-mistakes

This GitHub action turns Jupyter notebooks into Markdown posts to be used with the Minimal Mistakes Jekyll theme.

## Functionality
This action takes Jupyter notebooks stored in the `_notebooks/` folder, and turns them into Markdown posts stored in the `_posts/` folder. It also takes care of moving images to a location which gets picked up by Jekyll. Finally, it can optionally add badges to view the notebook on GitHub or in Google Colab.

The action does not check out the site, build the Jekyll site, or commit the new files, but it can be combined with other actions to take care of these tasks. See the example usage below for illustration.

Notebooks have to be stored in the `_notebooks` folder. The resulting Markdown files are stored under the same filename, replacing the `.ipynb` suffix by `.md`. The notebooks should therefore follow the typical Jekyll blog post naming convention `YYYY-MM-DD-title.ipynb`.

If notebooks start with a Markdown cell containing a YAML front matter, that will be preserved and later used by Jekyll.

## Prerequisites
This action should work with any Jekyll blog which uses the Minimal Mistakes theme.

The action defines a new `notebook` layout, which gets stored in `_layouts/notebook.html`. If this file exists, the action will not change it. This allows users to make changes to the layout.

## Badges
![Open on GitHub](https://img.shields.io/static/v1?label=&message=Open%20on%20GitHub&logo=github&color=lightgray&labelColor=gray)
![Open in Colab](https://colab.research.google.com/assets/colab-badge.svg)

This action optionally adds two badges at the beginning of the blog post that allow to view the generating notebook on GitHub or Google Colab. This functionality is enabled using the YAML front matter by setting `badges: true`. If `badges: false` or the `badges` tag is not set (default), the badges are not added.

## Example usage
The action can be used to convert Jupyter notebooks to Markdown posts before building the site with Jekyll and deploying it to GitHub pages. In this example, the current `main` branch of the blog repository (typically `<username>/<username>.github.io`) is checked out, then `jupyter-minimal-mistakes` is used to convert the notebooks before another action builds the site and pushes the result to the `gh_pages` branch.

```
jobs:
  build-site:
    runs-on: ubuntu-latest
    steps:
      # Check out current repo
      - name: Checkout current repository
        uses: actions/checkout@v2
      # Convert notebooks to Markdown posts
      - name: Convert Jupyter notebooks to Markdown blog posts
        uses: ptmerz/jupyter-minimal-mistakes@v1.0.0
      # Build and deploy the site
      - name: Build and deploy
        uses: EdricChan03/action-build-deploy-ghpages@v2.5.0
        env:
          JEKYLL_ENV: 'production'
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
```
