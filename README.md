# Boardgame Price Aggregator

A web application that aggregates board game prices from multiple game stores in Chile.

The goal is to provide an easy way to browse, compare, and track prices.

Check the [live website](https://turnoextra.cl)!

## Features

- Homepage sections:
  - New deals
  - Best deals
  - Most viewed
  - Top N BGG deals
- Board game search:
  - Search boar games by name using the BGG database
- BGG integration
- Board game details:
  - Metadata powered by the BGG API
  - List of available listings
  - Price history chart
- Contact messages:
  - General contact form
  - Board game error reports
- Administrative views:
  - Upload listing data via CSV
  - Manual listing matching
  - Manage contact messages
- Listing - Board game matching:
  - Groups listings under a common board game to allow comparisons
  - Programmatically identifies which board game a listing represents

## Notable Components

### Listing - BoardGame matching

Handles the logic for programmatically identifying which board game a given listing refers to.

It’s implemented using the following techniques:

- String normalization
- Trigram decomposition
- [Jaccard index similarity](https://en.wikipedia.org/wiki/Jaccard_index)
- BGG API `/search` calls
- Weighted average of name similarity and BGG rank (to resolve name collisions)

Relevant code:

- `app/services/identification/listing_identifier.rb`
- `app/services/search_method/search_result_ranker.rb`

### BoardGameGeek API integration

Wraps calls to the BGG API to fetch metadata; designed to eventually be extracted into a standalone gem.

Primarily responsible for parsing XML responses, with a thin cache layer.

Relevant code: lib/bgg/

### Price history & charts

Thanks to the listing identification process, all listings for the same board game can be compared simultaneously.

Having a price history chart allows users to spot fake deals or overpriced items at a glance.

Charts are built using the [chartkick gem](https://github.com/ankane/chartkick/).

Relevant code:

- `app/controllers/boardgames_controller.rb`
- `app/views/boardgames/show.html.erb`
- `app/views/boardgames/_price_chart.html.erb`.

### CSV ingestion

The application is intentionally built without web scraping functionality to maintain separation of concerns.

Listing data is uploaded via an HTML form and CSV files.

Relevant code:

- `app/services/listing_csv_import_service.rb`
- `app/controllers/admin/uploads_controller.rb`

### Admin functionality.

Admin dashboard for general executive tasks:

- Upload CSV data
- Highlight possible web scraping errors
- Listing matching:
  - Manually identify or unidentify
  - Manually mark as non-board game

Relevant code:

- `app/controllers/admin`
- `app/views/admin`.

## Technical Notes

- Built with Ruby on Rails
- Uses PostgreSQL as the database engine
- Runs inside Docker
- Deployed using Docker Compose:
  - [x] Rails application container
  - [x] PostgreSQL container
  - [ ] Background job worker container (currently disabled; workload is minimal, so the app can run using SOLID_QUEUE_IN_PUMA=true)
  - [ ] Nginx container (currently disabled; Nginx runs on the host to allow the host’s fail2ban service to access its logs)
- Deployed on a single DigitalOcean droplet VPS

## Roadmap

- Automate web scraping execution
  - Decide on an upload API (REST endpoint vs mounting a Docker directory and reading CSV files)
  - Implement proper observability, logging, and alerts to catch web scraping issues
- Better UI/UX
  - Allow users to filter by category, mechanics, author, year, etc.
  - Show related or similar items on `boardgames#show` pages
- Improve BGG metadata integration
  - Mark board games as Base Game or Expansion
  - Add support for RPGG items
- Extract BGG API integration into a standalone gem
- Implement ML/AI solutions for:
  - Listing name normalization
  - Listing - Board game matching
  - Non-board game listing detection

## Setup

### Environment Variables (`.env`)

In addition to the standard Rails and PostgreSQL environment variables, the project requires:

- Admin user seed:
  - ADMIN_EMAIL
  - ADMIN_PASSWORD
- BGG daily rank CSV download (requires user sign-in):
  - BGG_USERNAME
  - BGG_PASSWORD

## Acknowledgements

Inspired in websites like [solotodo](https://www.solotodo.cl/) and [knasta](https://knasta.cl/).

## License
