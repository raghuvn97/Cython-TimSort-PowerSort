# power_sort.pyx
import numpy as np
from libc.time cimport clock
from numpy cimport int32_t, ndarray

# Function to calculate the minimum run length (used in Timsort)
cdef int minRunLength(int n):
    cdef int r = 0
    while n >= 64:
        r |= n & 1
        n >>= 1
    return n + r

# Insertion Sort function for small subarrays
cdef void insertionSort(int32_t[:] arr, int left, int right):
    cdef int i, j, key
    for i in range(left + 1, right + 1):
        key = arr[i]
        j = i - 1
        while j >= left and arr[j] > key:
            arr[j + 1] = arr[j]
            j -= 1
        arr[j + 1] = key

# Merge function for merging two sorted subarrays
cdef void merge(int32_t[:] arr, int left, int mid, int right):
    cdef int len1 = mid - left + 1
    cdef int len2 = right - mid
    cdef int i, j, k

    # Initialize temporary arrays
    cdef int32_t[::1] leftArr = arr[left:mid + 1].copy()  # Avoid overwriting
    cdef int32_t[::1] rightArr = arr[mid + 1:right + 1].copy()

    i, j, k = 0, 0, left

    # Merge the arrays back into arr
    while i < len1 and j < len2:
        if leftArr[i] <= rightArr[j]:
            arr[k] = leftArr[i]
            i += 1
        else:
            arr[k] = rightArr[j]
            j += 1
        k += 1

    # Copy any remaining elements of leftArr
    while i < len1:
        arr[k] = leftArr[i]
        i += 1
        k += 1

    # Copy any remaining elements of rightArr
    while j < len2:
        arr[k] = rightArr[j]
        j += 1
        k += 1

# Power Sort function: Using insertion sort and merge
cpdef void powerSort(ndarray[int32_t, ndim=1] arr):
    cdef int n = arr.shape[0]
    cdef int minRun = minRunLength(n)
    cdef int start, size, left, mid, right

    # Sort subarrays using insertion sort
    for start in range(0, n, minRun):
        insertionSort(arr, start, min(start + minRun - 1, n - 1))

    # Merge sorted runs
    size = minRun
    while size < n:
        for left in range(0, n, 2 * size):
            mid = left + size - 1
            right = min((left + 2 * size - 1), (n - 1))
            if mid < right:
                merge(arr, left, mid, right)
        size = 2 * size