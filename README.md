# CrunchBase in 2013

This repository contains 7 digestable CSVs derived from the ["CrunchBase 2013 Snapshot"](https://data.crunchbase.com/docs/2013-snapshot) as made available by CrunchBase under [CC-BY](https://creativecommons.org/licenses/by/4.0/). It encompasses roughly 208,000 organizations, 227,000 people, 400,000 relationships, and 53,000 fundraising events.

All data in this repository was gathered prior to CrunchBase's relicensing (which disallows commercial use without payment) thus you may freely use this dataset as long as you provide appropriately credit CrunchBase.

This repository also contains the Ruby script used to convert the raw MySQL dump made available into the 7 CSVs. To run it, you will need Ruby, Docker, the `mysql2` gem, and typical UNIX tooling.

## How do you use this?

The script breaks the snapshot into 7 CSV files. There are unique identifiers provided, however,they do not line up with modern CrunchBase identifiers (which are now UUIDs).

Should you wish to use this dataset in tandem with modern CrunchBase data, you will need to use the provided CrunchBase URLs (usually `crunchbase_url`) to map to new identifiers, e.g. via ["Open Data Map"](https://data.crunchbase.com/docs/open-data-map). Please note that some assumptions about URLs, specifically around `FinancialOrg` objects that may break down when trying to "modernise" your dataset.

## How do I generate the CSVs?

You will need to be granted API access by CrunchBase. Once you have credentials, it's easy as `CB_USER_KEY=<Your API Key Here> ./dump.rb`. The script will download the snapshot for you and then convert it to CSVs.

---

These files are provided as is without warranty or guarantee of any kind. If you have any questions about the data, please direct your questions to CrunchBase.
