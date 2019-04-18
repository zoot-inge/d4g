#!/bin/bash

schema=$(basename $(pwd))

pg.sh -c "
    create schema ${schema}
    ;
"

pushd 1
mkdir -p shp
unzip *-shp.zip -d shp
pushd shp
shp2pgsql -D -I *.shp d4g.tbl_firestation > load.sql
pg.sh -f load.sql
popd
rm -rf shp
popd

pg.sh -c "
    create view d4g.vw_firestation as
    select gid as fid, geom
    from d4g.tbl_firestation
    ;
"
