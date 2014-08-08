Simple BASH CMS
===============

A really simple content management (CMS) system written in BASH for creating static websites. 

#### Why the hell I've created yet another CMS ... in BASH?

Well, this CMS is quite different. It allows you to edit your website locally, on your computer, without the need of internet connection and using your favorite editor (Vim, Emacs, ...) to edit the content. Then, some sort of magic is used to generate your entire website which consists of static HTML pages only, which are ready to be deployed to webserver.

## How to use it

Here is a step by step guide on how to use this really simple CMS.

**1. Clone Simple BASH CMS**  
Every new website starts by cloning this project in your website's directory on your local computer. So create a directory where your website will reside, say `my-website`, `cd` into it and clone this repository there using:

```
git clone https://github.com/rubickcz/simple-bash-cms.git
```

The directory `my-website` should now look something like this:

```
my-website/
└── simpe-bash-cms
    ├── config.sh
    ├── ...
    └── ...
```

#### 2. Edit your config.sh
Edit config options located in `config.sh` to fit your needs. Every option is commented so you get an idea what it does.

#### 3. Create layout of your website

Now you need to have layout of your website in single HTML file. Just some page with sample content, what's important now is to have layout (header and footer) of your website ready. You can use images, CSS styles etc.

Create directory called `input` in your website root, which will contain all information needed as input to generate your website. Inside this directory, create another ones called `layout`, `static` and `content`. This directory layout is not mandatory. You can use your own, but be sure to edit paths in `config.sh`.

Split your layout into two halfs: `header.html` and `footer.html` and place the into `input/layout/`. Any static files like images, CSS styles, JS files etc. place in `input/static/`. From here, they will be simply copied to final website and will reside in `static/` directory in your website root.

Copy other static files like images, javascript files, CSS styles etc. into `input/static/`. You may need to edit paths in your layout HTML, since these files will be copied in `static/` directory of your generated website root.

The, the directory `my-website` should now look something like this:

```
my-website/
├── simpe-bash-cms
│   ├── config.sh
│   ├── ...
│   └── ...
└── input
    ├── content
    ├── layout
    │   ├── footer.html
    │   └── header.html
    └── static
        └── screen.css 

```

#### 4. Add some content

We're ready to add some content! 

## Required command line tools

These command line tools are required for Simple BASH CMS to operate:

```
awk, sed, lftp
```

# Author

Ondřej Kulatý aka rubick.

# License

This software is licensed unde GNU GPLv2.
