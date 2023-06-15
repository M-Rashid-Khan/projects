### rashidm-taxi dataset working

## Initials:
Uploading dataset to into the environment:

Note* (I have used [trip_data_7](https://clarksonmsda.org/datafiles/taxi_trips/trip_data_7.csv.zip) dataset for my project)
```python

import csv
with open('trip_data_7.csv') as f: 
    data = [{k:str(v) for k, v in row.items()}
           for row in csv.DictReader(f, skipinitialspace=True)]

```
1. What datetime range does your data cover?  How many rows are there total?

```python
len(data)
import csv 
# import time
import datetime
# n=0
# start= time.time()
max_dtime = None
min_dtime = None

with open('trip_data_7.csv', 'r') as f: 
    reader = csv.reader(f)
    n = 0
    for i,line in enumerate(reader):
        if i == 1:
            max_dtime= datetime.datetime.strptime(line[5],'%Y-%m-%d %H:%M:%S')
            min_dtime= datetime.datetime.strptime(line[5],'%Y-%m-%d %H:%M:%S')
        #print(type(max_dtime),type(min_dtime))
        
        if i>1 and datetime.datetime.strptime(line[5],'%Y-%m-%d %H:%M:%S') > max_dtime:
            max_dtime= datetime.datetime.strptime(line[5],'%Y-%m-%d %H:%M:%S')
        if i>1 and datetime.datetime.strptime(line[5],'%Y-%m-%d %H:%M:%S') < min_dtime:
            min_dtime = datetime.datetime.strptime(line[5],'%Y-%m-%d %H:%M:%S')
    n+=1
print("Range - upper vs lower of dates and time for pickup_datetime attribute in the data:  " , max_dtime, min_dtime)
print("Total rows are: ", n)

```
![range_dates](/images/image0.png)
Number of Rows for this dataset are : 13,823,840

2. What are the field names?  Give descriptions for each field.
```python
import csv 
# import time
import datetime
with open('trip_data_7.csv', 'r') as f: 
    reader = csv.reader(f)
    for i,line in enumerate(reader):
        print('Field Names: ', line)
        break
```
![field_name](/images/image1.png)


3. Give some sample data for each field.

```python
import csv 
import datetime
with open('trip_data_7.csv', 'r') as f: 
    reader = csv.reader(f)
    for i,line in enumerate(reader):
        print(line)
        if i > 1:
            
        if i == 5:
            break
            
```

![sampel_data](/images/image2.png)

4. What MySQL data types / len would you need to store each of the fields? 
    - int(xx), varchar(xx),date,datetime,bool, decimal(m,d)
    
| Fields | SQL Data Types |
| :---:   | :---: |
| medallion | varchar(50)  |
| hack_license | varchar(50) |
| vendor_id | varchar(5) |
| rate_code | int(10) |
| store_and_fwd_flag | bool |
| pickup_datetime | datetime |
| dropoff_datetime | datetime |
| passenger_count | int(10) |
| trip_time_in_secs | int(10) |
| trip_distance | Decimal(5,5) |
| pickup_longitude | Decimal(9,6) |
| pickup_latitude | Decimal(8,6) |
| dropoff_longitude | Decimal(9,6) |
| dropoff_latitude | Decimal(8,6) |


5. What is the geographic range of your data (min/max - X/Y)? 
    - Plot this (approximately on a [map](http://www.gps-coordinates.net/))
    
```python
import csv 
# import time
import datetime
with open('trip_data_7.csv', 'r') as f: 
    reader = csv.reader(f)
    n = 0
    fs = ""
    for i,line in enumerate(reader):
        if i==1:
            pick_max_long = line[10]
            pick_max_lat = line[11]
            drop_min_long = line[12]
            drop_min_lat = line[13]
        if i >=  1:
            p0= "["
            p1 = line[10]
            p2 = ","
            p3 = line[11]
            p4 = "]"
            s = p0 + p1 + p2 + p3 + p4
            #print(s)
            fs += s
            fs += ","
            s = ""
            
            p0= "["
            p1 = line[12]
            p2 = ","
            p3 = line[13]
            p4 = "]"
            s = p0 + p1 + p2 + p3 + p4
            
            fs += s
            fs += ","
            s = ""
            
            if i == 10:
                p0= "["
                p1 = pick_max_long
                p2 = ","
                p3 = pick_max_lat
                p4 = "]"
                s += p0 + p1 + p2 + p3 + p4
                fs += s
                s = ""
                print(fs)
                break
```

[GeoJson Map](/map/map.geojson)

6. What is the average computed trip distance? (You should use [Haversine Distance](https://stackoverflow.com/a/4913653))
- Draw a histogram of the trip distances binned anyway you see fit.

Using the Haversine Distance method below: 

```python
def haversine(lon1, lat1, lon2, lat2):
    """
    Calculate the great circle distance in kilometers between two points 
    on the earth (specified in decimal degrees)
    """
    # convert decimal degrees to radians 
    lon1, lat1, lon2, lat2 = map(radians, [lon1, lat1, lon2, lat2])

    # haversine formula 
    dlon = lon2 - lon1 
    dlat = lat2 - lat1 
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * asin(sqrt(a)) 
    r = 6371 # Radius of earth in kilometers. Use 3956 for miles. Determines return value units.
    return c * r
```

Calculating distance for pick and drop positions and adding to list for visualization: 

```python

#using the above method for finding haversine for distance b/w two points (GPS)
import csv
from math import radians, cos, sin, asin, sqrt
f = open("trip_data_7.csv", 'r')
reader = csv.reader(f)
i=0
total_distance = 0.0
error =0
d_list = []
for row in reader:
  i+=1
  try:
    lon1,lat1,lon2,lat2 = float(row[10]),float(row[11]),float(row[12]),float(row[13])
    total_distance += haversine(lon1,lat1,lon2,lat2)
    d_list.append(total_distance)
  except Exception as e:
    error +=1
print("Error in distance : ", error)
d = i-error
print(d)
print("Avg. Haversine-Distance =", total_distance/d)

```
Average Haversine Distance = 17.596408730518675

- Histogram of the trip distances

```python
from matplotlib import pyplot as plt
plt.style.use('seaborn')
fig, ax = plt.subplots(figsize =(10, 7))
ax.hist(trip_distance, bins = [0,5,10,15,20,25,30])
plt.show()

```

![histogram1](/images/image3.png)

7. What are the distinct values for each field? (If applicable)

![distint_values](/images/image4.png)


8. For other numeric types besides lat and lon, what are the min and max values?

![max_min_values](/images/image5.png)

9. Create a chart which shows the average number of passengers each hour of the day. (X axis should have 24 hours)

```python
import datetime
import csv
f = open("trip_data_7.csv", 'r')
reader = csv.reader(f)
for i,line in enumerate(reader):
    if i == 1:
        print(line[5])
    break
exp =0
n=0
pcl =  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
hc =  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
for row in reader:
    n+=1
    try:
        dts = row[5]
        dto = datetime.datetime.strptime(dts,"%Y-%m-%d %H:%M:%S")
    except Exception as e:
        exp+=1
        print(e)
    h = dto.hour  
        
    try:
        ipc = int(row[7])    
        hc[h]+=1
        pcl[h]+=ipc
        
    except Exception as e:
        print(e)

averages = []

for i in range(len(hc)):
    averages.append(pcl[i]/hc[i])
    
from matplotlib import pyplot as plt
plt.style.use('seaborn') 
plt.figure(figsize=(20,6))
plt.xlabel('Hour of the day')
plt.ylabel('Average number of taxi passengers')
plt.title('Average number of taxi passengers for each hour of the day')
plt.bar(x=range(0,24), height=averages)
plt.show()

```

![avg.passengers](/images/image6.png)

10. Create a new CSV file which has only one out of every thousand rows.
```python
import csv
fn = 'trip_data_7.csv'
f = open(fn, 'r')
reader = csv.reader(f)
fnew = open('new.csv', 'w')
fnew.write('')
fnew.close()
fnew = open('new.csv', 'w')
writer = csv.writer(fnew,delimiter=',',lineterminator='\n')
n = 0
nn=0
for row in reader:
    if n % 1000 == 0:
        nn+=1
        writer.writerow(row)
    n+=1
fnew.close
```
11. Repeat step 9 with the reduced dataset and compare the two charts.
```python
import datetime,csv
f = open("new.csv", 'r')
reader = csv.reader(f)
exp =0
n=0
pcl =  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
hc =  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
for row in reader:
    n+=1
    try:
        dts = row[5]
        dto = datetime.datetime.strptime(dts,"%Y-%m-%d %H:%M:%S")
    except Exception as e:
        exp+=1
        print(e)
    h = dto.hour          
    try:
        ipc = int(row[7])    
        hc[h]+=1
        pcl[h]+=ipc      
    except Exception as e:
        print(e)
averages = []
for i in range(len(hc)):
    averages.append(pcl[i]/hc[i])   
from matplotlib import pyplot as plt
plt.style.use('seaborn')
plt.figure(figsize=(20,6))
plt.xlabel('Hour of the day')
plt.ylabel('Average number of taxi passengers')
plt.title('Average number of taxi passengers for each hour of the day')
plt.bar(x=range(0,24), height=averages)
plt.show()

```

![reduced_csv](/images/image7.png)

<!---
![ScreenShot](images/img1.png)
--->

<!---
This is how code can be displayed: 

```python
print("hello")

```
--->
