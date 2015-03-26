# OSM Bright Mobile

![screenshot](https://raw.github.com/halvards/osm-bright-mobile/master/preview.png)

OSM Bright Mobile is a fork of [OSM Bright](https://github.com/mapbox/osm-bright), adapted for use on small screens, such as mobile phones.

The main difference compared to OSM Bright is that font sizes have been increased for better readability.

This style can be used with either [Mapnik](http://mapnik.org/) or [TileMill](https://www.mapbox.com/tilemill/).

## Use as-is with Mapnik

You'll need `osm-bright-mobile.xml` from the `osm-bright` directory, as well as the subdirectories `fonts`, `img`, and `res`.

The provided Mapnik XML style file assumes the following:

- The OpenStreetMap data is in a PostGIS database called `osm`
- The `osm` database is accessible on the same host, using [peer authentication](http://www.postgresql.org/docs/9.3/static/auth-methods.html#AUTH-PEER)
- The required shapefiles have been extracted to the directory `/etc/mapnik-osm-carto-data/data`. (This is the default location when installing the Ubuntu package [openstreetmap-mapnik-carto-stylesheet-data](https://launchpad.net/~kakrueger/+archive/ubuntu/openstreetmap/+build/5993349), which is installed as a dependency of [libapache2-mod-tile](https://launchpad.net/~kakrueger/+archive/ubuntu/openstreetmap/+build/6023456).)

If these do not match your setup, please read the following sections for instructions on how to customise the XML style file.

Configure `renderd` (`/etc/renderd.conf` if installing from a package, `/usr/local/etc/renderd.conf` by default if installing from source) to point to the location of `osm-bright-mobile.xml` and ensure that the subdirectories (`fonts`, `img`, and `res`) are also present.

## Use with TileMill

OSM Bright Mobile is written in the [CartoCSS](https://www.mapbox.com/tilemill/docs/manual/carto/) styling language and can be opened with TileMill for further customisation.

Read on for instructions on how to generate the TileMill project files.

## Edit the configuration

You may need to adjust some settings for things like your PostgreSQL connection information or the location of the required shapefiles.

1. Make a copy of `configure.py.sample` and name it `configure.py`.

    cp configure.py.sample configure.py

2. Open `configure.py` in a text editor.
3. Make sure the "importer" option matches the program you used to import your data (either "osm2pgsql" or "imposm").
4. Optionally change the name of your project from the default, "OSM Bright Mobile".
5. Adjust, if needed, the path to point to your MapBox project directory.
6. Make any adjustments to the PostgreSQL connection settings. Your database may be set up so that you require a password or different user name.
7. Optionally adjust the query extents or shapefile locations. Refer to the comments in the configuration file for more information.

## Generate the Mapnik XML file

If you have modified data source configuration or the style itself, you'll need to regenerate the Mapnik XML style file to use the style with Mapnik.

To do this, you must have the [`carto`](https://github.com/mapbox/carto) NodeJS module installed. If you have installed TileMill, you already have this.

If not, install NodeJS, NPM and carto with the following commands for Mac:

    brew update && brew install node010
    npm install carto

See https://github.com/nodesource/distributions for instructions on how to install NodeJS and NPM on Linux.

First, generate the TileMill project files. Note that you do not need to have TileMill installed to run this script:

    ./make.py build

Then, regenerate the Mapnik XML file with this command:

    carto build/project.mml > osm-bright/osm-bright-mobile.xml

You can run this in either the `build` subdirectory, or in the MapBox project directory.

## Generate the TileMill project

Run this command to generate the TileMill project files:

    ./make.py

This will create a new directory called `build` with your new project, customized with the variables you set in `configure.py` and install a copy of this build to your MapBox project directory. If you open up TileMill you should see your new map in the project listing.

Have patience: the first time the project opens it needs to download very large shapefiles before the map can render. This can take 5-10 minutes on a fast connection and longer on a slow connection. Keep TileMill open and feel free to navigate back to the projects view then back to the project editor view to check on its loading status. You can also check the TileMill logs to see the download status of the remote files.

## Required shapefiles

OSM Bright Mobile depends on two large shapefiles. You will need to download and extract them to use this style.

- <http://data.openstreetmapdata.com/simplified-land-polygons-complete-3857.zip>
- <http://data.openstreetmapdata.com/land-polygons-split-3857.zip>

If using Ubuntu, add the [ppa:kakrueger/openstreetmap](https://launchpad.net/~kakrueger/+archive/ubuntu/openstreetmap) PPA and install the package `openstreetmap-mapnik-carto-stylesheet-data`.

## OpenStreetMap data

You must also have a PostGIS database containing OpenStreetMap (OSM) data. The easiest way to get this up and running is to use a Vagrant-based virtual machine. Fully automated scripts are available for [Ubunbu 14.04](https://github.com/halvards/vagrant-vm/tree/ansible/maptiles-ubuntu64) and [CentOS 6.x](https://github.com/halvards/vagrant-vm/tree/ansible/maptiles-centos64).

These scripts set up OSM data for Australia. To add data for other regions, you need to download an OSM database extract (ideally as `.osm.pbf`) and add it to the PostGIS database using `osm2pgsql`

You can find appropriate data extracts for a variety of regions and countries at <http://download.geofabrik.de>, or city extracts at <https://mapzen.com/metro-extracts/>.

You need to process this data and import it to your PostGIS database. You can either look at the Ansible playbooks of the provided Vagrant virtual machines, or for the impatient, run this command:

    osm2pgsql --slim --cache 1024 --cache-strategy=dense \
      -U <postgres_user> -d <postgis_database> <data.osm.pbf>

See `man osm2pgsql` or the [online documentation](http://wiki.openstreetmap.org/wiki/Osm2pgsql) for more details.

## Using Imposm (untested!)

If you are using [Imposm](http://imposm.org/), you should use the [included mapping configuration](https://github.com/halvards/osm-bright-mobile/blob/master/imposm-mapping.py) when importing the OSM data, as it includes a few important tags compared to the default. The Imposm import command looks like this:

    imposm -U <postgres_user> -d <postgis_database> \
      -m /path/to/osm-bright-mobile/imposm-mapping.py --read --write \
      --optimize --deploy-production-tables <data.osm.pbf>

See `imposm --help` or the [online documentation](http://imposm.org/) for more details.

Note that as I don't use Imposm, I have not tested these instructions.

