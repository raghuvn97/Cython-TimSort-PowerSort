import numpy as np
import time
import csv
from tim_sort import timSort
from power_sort import powerSort

# Function to record time taken for sorting
def record_sort_time(sort_func, arr):
    start_time = time.time()
    sort_func(arr)
    end_time = time.time()
    return (end_time - start_time) * 1000  # Time in milliseconds

# Array sizes to test (from 50,000 to 50,000,000 in 100 steps)
array_sizes = np.linspace(50000, 50000000, 100, dtype=int)

# Prepare to write data to CSV
with open('sort_times.csv', mode='w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['timetaken_timSort', 'size_timSort', 'timetaken_powerSort', 'size_powerSort'])

    # Loop through array sizes
    for size in array_sizes:
        # Generate random array of given size
        arr_timSort = np.random.randint(0, 100000, size=size, dtype=np.int32)
        arr_powerSort = arr_timSort.copy()  # Same array for both sorts

        # Record sorting times
        tim_sort_time = record_sort_time(timSort, arr_timSort)
        power_sort_time = record_sort_time(powerSort, arr_powerSort)

        # Write results to CSV
        writer.writerow([tim_sort_time, size, power_sort_time, size])

print("Sorting times have been recorded in 'sort_times.csv'.")

