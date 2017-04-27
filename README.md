# Govuk-nav-prototype

This app serves up prototype navigation flows for the work-in-progress GOV.UK
navigation.

The `master` branch is automatically deployed to https://govuk-nav-prototype.herokuapp.com/

## Live examples

- [the home page](https://govuk-nav-prototype.herokuapp.com/)
- [previous iterations](https://govuk-nav-prototype.herokuapp.com/prototype)

## Nomenclature

- **Taxon**: a single node within a taxonomy that content items are tagged to.

## Technical documentation

This is a Ruby on Rails application that displays the following:

### New navigation pages (.e.g. /education)

We have copied the code for the new navigation pages currently being rendered
by `collections` in production into this repository. This will make it easy to
both update and understand.

### Guidance content items (e.g. /government/publications/governance-handbook)

We fetch the production version of the content item's HTML, parse it and extract
the `main` tag. We then insert that within the navigation elements we want to
use, such as breadcrumbs and related links.

### GOV.UK home page (and other non-guidance pages)

We display the GOV.UK homepage, currently being rendered by `frontend`, by also
fetching its HTML. In this case, we show it as-is from production without
parsing the HTML.

### Dependencies

- [content store](https://github.com/alphagov/content-store)
- [search API](https://github.com/alphagov/rummager)
- [static](https://github.com/alphagov/static)
- [govuk_frontend_toolkit](https://github.com/alphagov/govuk_frontend_toolkit)
- [govuk_navigation_helpers](https://github.com/alphagov/govuk_navigation_helpers)

### Running the application locally

First clone the repository:

```
$ cd ~/govuk
$ git clone git@github.com:alphagov/govuk-nav-prototype.git
$ cd govuk-nav-prototype
```

Then, install the dependencies with:

```
bundle install
```

And finally start the server with:

```
foreman start
```

This will start the application on `http://localhost:5000`.

### Deploy to Heroku

In order to deploy your code to Heroku, you will need a Heroku account. Please
create one with your work email address and ask a team member to add yourself to
the Heroku application.

Then:

- install the Toolbelt (https://devcenter.heroku.com/articles/heroku-cli)
- login via the CLI tool with `heroku login`

At this point you can add the heroku app as a remote:

```
$ cd ~/govuk/govuk-nav-prototype
$ heroku git:remote -a govuk-nav-prototype
```

In order to check it's working properly, run the following command:

```
git fetch --all
```

If the command runs without errors, you should have access to the Heroku app.

The application is deployed automatically on a successful PR merge, which means
we don't generally have to manually deploy the app. However, if you would like
to push a certain version live, you can push it to the correct remote:

```
git push heroku master
```

## Licence

[MIT License](LICENCE)
