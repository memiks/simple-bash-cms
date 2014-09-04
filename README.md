Simple BASH CMS
===============

A really simple command-line content management (CMS) system written in BASH
for creating static websites. The word **simple** in the title might make you
think it's for beginners. No it's not, it's simple in it's design and therefore
requires some knowledge from you. You should know how to edit webpages in HTML
and have some experience with Linux command line.

#### Why the hell I've created yet another CMS ... in BASH?

Well, this CMS is quite different. It allows you to edit your website locally,
on your computer, without the need of internet connection and using your
favorite editor (Vim, Emacs, ...) to edit the content. Then, some sort of magic
is used to generate your entire website which consists of static HTML pages
only, which are ready to be deployed to webserver. Without the need to manually
connect to FTP and copy files by hand.

## How to use it

Here is a step by step guide on how to use this CMS.

#### 1. Clone Simple BASH CMS
Every new website starts by cloning this project in your website's directory on
your local computer. So create a directory where your website will reside, say
`my-website/`, `cd` into it and clone this repository there using:

```
git clone https://github.com/rubickcz/simple-bash-cms.git
```

The directory `my-website/` should now look something like this:

```
my-website/
└── simpe-bash-cms
    ├── config.sh
    ├── ...
    └── ...
```

From now on, all paths I will mention will be relative to `my-website/` directory.

#### 2. Edit your config.sh
Edit config options located in `simple-bash-cms/config.sh` to fit your needs.
Every option is commented so you get an idea what it does.

#### 3. Create basic directory structure

We will now create basic directory structure. Altough it's not mandatory and
you can create your own, I recommend you to follow this one, at least for the
first time. If you decide to use your own directory layout, be sure to edit
paths in `simple-bash-cms/config.sh`.

So create a directory `input/`, which will contain all information needed as
input to generate your website. Inside this directory, create another ones
called `layout/` (chunks of HTML - header and footer of your website),
`static/` (static files like images, CSS styles, javascript files, etc.) and
`content/` (files with content, every file represents single page of your
website)

The directory `my-website` should now look something like this:

```
my-website/
├── simpe-bash-cms
│   ├── config.sh
│   ├── ...
│   └── ...
└── input
    ├── content
    ├── layout
    └── static

```

#### 3. Create HTML layout of your website

Now you need to have layout of your website in single HTML file. Just some page
with sample content, what's important now is to have layout (header and footer)
of your website ready. Use your favorite editor or some free template from the
internet, it's up to you. And of course, you can use images, CSS styles etc.
This is very simplified example of such a page (I have added HTML comments to
clearly distuinguish header and footer sections):

```
<!-- HEADER START -->
<html>
  <head>
    <title>#title# - My website</title>
    <base href="#basehref#" />
    <link rel="stylesheet" href="static/screen.css" type="text/css" />
  </head>
  <body>
  
<!-- HEADER END -->

    <p>Some sample content...</p>

<!-- FOOTER START -->

    <p>Last change of this page: #lastchanged#</p>
  </body>
<html>
<!-- FOOTER END -->
```

Notice that I have used three special tags between `#` signs. These tags will
be substituted by actual values during generation of the website. For more
information on these tags, see section in the bottom.

We need only HEADER and FOOTER sections so split your layout into two halfs:
`header.html` and `footer.html` and place them into `input/layout/`. Any static
files like images, CSS styles, JS files etc. place in `input/static/`. From
here, they will be simply copied to final website and will reside in `static/`
directory in your website root, so adjust your paths in HTML accordingly.

The directory `my-website/` should now look something like this:

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
        ├── screen.css 
        └── ...

```

#### 4. Add some content

We're ready to add some content! As you might have guessed, it will reside in
`input/content/` directory. Every file you create there represents single web
page of your website. You are allowed to create three things in this directory:

1. `*.html` files with content in HTML.
2. `*.md` files with content in Markdown.
3. Directories. You can even nest them to better organize your files.
 
For example, create file `index.html` in `input/content/` directory with following content:

```
<h1>My first page</h1>
<p>Hello world!</p>
```

#### 5. Generate your website

We will now use first tool of this CMS, the `generate.sh` script. Be sure your
are in your website root directory an invoke generate.sh without any
parameters:

```
./generate.sh
```

After a while, first page of your website should emerge in newly created
`output/` directory. Now I am going to tell you what happens with those content
files during website generation so you will better understand what to put
inside them. The script `generate.sh` simply takes every file and glues the
header file on top and footer on bottom. 

This is what happens to our `input/content/index.html` file during generation:

```
--------------------------------------------
|                                          |
|   Contents of input/layout/header.html   |
|                                          |
--------------------------------------------
                      +
--------------------------------------------
|                                          |
|   Contents of input/content/index.html   |
|                                          |
--------------------------------------------
                      +
--------------------------------------------
|                                          |
|   Contents of input/layout/footer.html   |
|                                          |
--------------------------------------------
                      |
                      |
                      v
              output/index.html
```

The file `output/index.html` looks like this:

```
<html>
  <head>
    <title>My first page - My website</title>
    <base href="/" />
    <link rel="stylesheet" href="static/screen.css" type="text/css" />
  </head>
  <body>
  
<h1>My first page</h1>
<p>Hello world!</p>

    <p>Last change of this page: Sat 28 Dec 2013 10:52:55 PM CET</p>
  </body>
<html>
```

Now you can add more files and connect them together with hyperlinks. Be sure
to always use path realtive to your website root in your hyperlinks.

#### 5. Upload your website to remote server

You don't need to open FTP client and copy all files by hand anymore.
`publish.sh` will upload website files in smart way - only differences will be
uploaded. This is accomplished thanks to mirror feature of lftp command line
client. Make sure you have edited FTP settings in `simple-bash-cms/config.sh`,
`cd` into website root and invoke command:

```
./simple-bash-cms/publish.sh
```

## Special tags

As mentioned in previous section, you can use special tags which will be
substituted with actual values. Following tags are available:

### The TITLE tag

Every page should have unique title. Tag `#title` should be placed in your html
header. Simple BASH CMS searches for title in this order:

1. In line beginning with `title:`. You can put it on top of your content page inside HTML comment:
```
<!--
title: My page
-->
```
2. In h1 HTML tag:
```
<h1>My page</h1>
```
3. In h1 markdown tag:
```
# My page
```

### The BASEHREF tag



## Required command line tools

These command line tools are required for Simple BASH CMS to operate:

```
awk, sed, lftp
```

# Author

Ondřej Kulatý aka rubick.

# License

This software is licensed unde GNU GPLv2.
