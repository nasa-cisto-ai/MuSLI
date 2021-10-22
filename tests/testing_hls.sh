#!/bin/bash
# Usage: bash testing_hls.sh $filename_to_test
# Author: Jordan A. Caraballo-Vega, jordan.a.caraballo-vega@nasa.gov

FILENAME=$1
GDAL_INFO=`gdalinfo ${FILENAME}`

echo "File checks for Testing (Pass/Fail)"

# Checks
PROJS=`grep -q "WGS 84 / UTM zone 18N" <<<  "$GDAL_INFO" && echo Pass || echo Fail`
NODATA=`grep -q "Value=-9999" <<<  "$GDAL_INFO" && echo Pass || echo Fail`
COMPRESSION=`grep -q "COMPRESSION=LZW" <<<  "$GDAL_INFO" && echo Pass || echo Fail`
DRIVER=`grep -q "Driver: GTiff/GeoTIFF" <<<  "$GDAL_INFO" && echo Pass || echo Fail`

echo "PROJS (WGS 84 / UTM zone 18N): ${PROJS}"
echo "NODATA (-9999): ${NODATA}"
echo "COMPRESSION (LZW): ${COMPRESSION}"
echo "DRIVER (GTiff/GeoTIFF): ${DRIVER}"
