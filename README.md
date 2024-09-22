# TACIO Website

This is a Jekyll and Node.js based website for the TACIO project at https://taico.ca.

## To Run Locally

This is how to run the website locally on Linux. The process would be similar for other operating systems.

## Prerequisites

- Ubuntu-based system
- Git

## Installation Steps

At the end, we should have something like this:

```
$ ruby --version
ruby 3.3.5 (2024-09-03 revision ef084cc8f4) [x86_64-linux]
$ nvm --version
0.40.1
$ node --version
v20.17.0
$ npm --version
10.8.2
```

1. Update system packages:
   ```
   sudo apt update
   ```

2. Install required dependencies:
   ```
   sudo apt install git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev imagemagick
   ```

3. Install rbenv:
   ```
   git clone https://github.com/rbenv/rbenv.git ~/.rbenv
   echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
   echo 'eval "$(rbenv init -)"' >> ~/.bashrc
   source ~/.bashrc
   ```

4. Install ruby-build plugin:
   ```
   git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
   ```

5. Install Ruby 3.3.5:
   ```
   rbenv install 3.3.5
   rbenv local 3.3.5
   ```

6. Install Bundler:
   ```
   gem install bundler
   ```

7. Install nvm (Node Version Manager):
   ```
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
   source ~/.bashrc
   ```

8. Install Node.js (LTS version):
   ```
   nvm install --lts
   ```

9. Clone the website repository:
   ```
   git clone https://github.com/taicodotca/taico-website.git
   cd taico-website
   ```

10. Install Ruby dependencies:
    ```
    bundle install
    ```

11. Install Node.js dependencies:
    ```
    npm install
    ```

## Running the Website Locally

To run the Jekyll website locally:

```
bundle exec jekyll serve
```

You can now access the website at `http://<your-ip-address>:4000`.

## Licensing

This project uses multiple licenses:

- Images: Copyright © 2024 by their respective authors. All rights reserved.
- Posts/Content: Copyright © 2024 by their respective authors. All rights reserved.
- Website Template: GNU General Public License v3.0 (GPL-3.0)

Please see the `LICENSE` file for full details.