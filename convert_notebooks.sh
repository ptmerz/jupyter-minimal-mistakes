#!/bin/bash

# Sanity checks for root directory
if [ ! -d ./_posts ]; then
  echo "Cannot find posts directory ./_posts" >&2
  exit 1
fi
if [ ! -d ./_notebooks ]; then
  echo "Cannot find notebook directory ./_notebooks" >&2
  exit 1
fi
if [ ! -d ./assets/images/ ]; then
  echo "Cannot find image directory ./assets/images/" >&2
  exit 1
fi
root_directory=$PWD

cd _notebooks || exit 1
for notebook_file in *.ipynb; do
  # Get file name without extension
  filename="${notebook_file%.*}"

  echo "Converting $notebook_file ..."
  # Name of Markdown file will be base name + ".md"
  md_notebook="${filename}.md"
  # Convert notebook to Markdown
  jupyter nbconvert "$notebook_file" --to markdown
  # Fix image links to point to a place where Jekyll will pick up the images
  perl -pi -e 's/\!\[png\]\(/![png]({{ site.url }}{{ site.baseurl }}\/assets\/images\//g' "$md_notebook"
  
  # Check if there is a YAML front matter
  if [ "$(sed -n '/^---$/p;q' "$md_notebook")" ]; then
    perl -pi -e "s/---/---\nlayout: notebook\nfilename: \"$notebook_file\"/ if 1 .. 1" "$md_notebook"
  else
    perl -pi -e "s/^/---\nlayout: notebook\nfilename: \"$notebook_file\"\n---\n/ if 1 .. 1" "$md_notebook"
  fi
  
  # Move Markdown notebook to _posts/ directory
  rm -f "${root_directory}/_posts/${md_notebook}"
  mv "$md_notebook" "${root_directory}/_posts/"
  # Move images to a assets such that Jekyll finds them
  rm -rf "${root_directory}/assets/images/${filename}_files"
  mv "${filename}_files" "${root_directory}/assets/images/"
done
cd "$root_directory" || exit 1
