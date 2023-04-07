#!/usr/bin/python3
import os
import sys
import csv
import re


LOG_FOLDER = './logs'
FROM_DATETIME = '0000-00-00'
TO_DATETIME = '9999-99-99'
GRANULARITY = '30min'
GROUP_BY_APP = 'no'


class Query:
    def __init__(self, user, from_datetime, to_datetime):
        self.user = user
        self.from_datetime = from_datetime
        self.to_datetime = to_datetime

    def log_files(self):
        from_datetime = self.from_datetime
        to_datetime = self.to_datetime
        log_files = get_log_files(log_folder, from_datetime, to_datetime)
        return log_files

    def query(self, granularity, group_by_app):
        log_files = self.log_files()
        result = []
        for file in log_files:
            query = get_query(file, self.user, group_by_app, granularity)
            resut.extend(query)
        return result

    def __str__(self):
        return f"Query result for: User: {self.user}, from_datetime: {self.from_datetime}, to_datetime: {self.to_datetime}"


def get_log_files(log_folder, from_datetime, to_datetime):
    log_files = []
    files = os.listdir(log_folder)
    for file in files:
        date = file.split('.')[0].replace('-', '')
        if date >= from_datetime.replace('-', '') and date <= to_datetime.replace('-', ''):
            file_path = os.path.join(log_folder, file)
            log_files.append(file_path)
    return log_files


def get_query(file, user, group_by_app, granularity):
    date = file.split('/')[2].split('.')[0]
    with open(file, 'rt') as f:    
        metric_by_time = {}
        apps = {}
        reader = csv.DictReader(f)

        if granularity == '30min' and group_by_app == 'no':
            for row in reader:
                if row['user'] == user:
                    if row['timestamp'] not in metric_by_time:
                        metric_by_time[row['timestamp']] = float(row['metric1'])
                    else:
                        metric_by_time[row['timestamp']] += float(row['metric1'])
            statistics_by_30min = []
            for key, value in metric_by_time.items():
                statistics_by_30min.append(f"{user}, {key}, {value}")
            return statistics_by_30min

        if granularity == '30min' and group_by_app == 'yes':
            for row in reader:
                app = row['app'] 
                if row['user'] == user and row['app'] == app:
                    if row['timestamp'] not in metric_by_time:
                        metric_by_time[app + ', ' + row['timestamp']] = float(row['metric1'])
                    else:
                        metric_by_time[app + ', ' + row['timestamp']] += float(row['metric1'])
            statistics_by_30min_groupbyapp = []
            for key, value in metric_by_time.items():
                statistics_by_30min_groupbyapp.append(f"{user}, {key}, {value}")
            return statistics_by_30min_groupbyapp
        
        if granularity == '1day' and group_by_app == 'no':
            metric_by_day = 0
            for row in reader:
                if row['user'] == user:
                    metric_by_day += (float(row['metric1']))  
            statistics_in_1day = []
            statistics_in_1day.append(f"{user}, {date} 00:00:00, {metric_by_day}")
            return statistics_in_1day

        if granularity == '1day' and group_by_app == 'yes':
            for row in reader:
                app = row['app']
                if row['user'] == user: 
                    if row['app'] not in apps:
                        apps[app] = float(row['metric1'])
                    else:
                        apps[app] += float(row['metric1'])
            statistics_in_1day_groupbyapp = []
            for key, value in apps.items():
                statistics_in_1day_groupbyapp.append(f"{user}, {key}, {date} 00:00:00, {value}")
            return statistics_in_1day_groupbyapp


def solve():
    query = Query(user, from_datetime, to_datetime)
    result = query.query(granularity, group_by_app)
    return result


if __name__ == '__main__':

    try: 
        user = sys.argv[1]
    except:
        user = input("Enter user name: ")

    try:
        log_folder = sys.argv[2]
    except:
        log_folder = LOG_FOLDER

    from_datetime = input("Enter from_datetime (format: yyyy-mm-dd): ")
    to_datetime = input("Enter to_datetime (format: yyyy-mm-dd): ")
    if from_datetime == '':
        from_datetime = FROM_DATETIME
    if to_datetime == '':
        to_datetime = TO_DATETIME

    granularity = input("Enter granularity (30min or 1day): ")
    group_by_app = input("Enter group_by_app (yes or no): ")
    if granularity != '30min' and granularity != '1day':
        granularity = GRANULARITY
    if group_by_app != 'yes' and group_by_app != 'no':
        group_by_app = GROUP_BY_APP

    result = solve()
    for item in result:
        print(item)