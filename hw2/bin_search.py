arr = [ -40, -25, -1 , 0 , 100, 300 ]
l=0
r = len(arr)-1
x = 0

found = False
while l <= r:
    mid = l + (r-l) // 2
    if arr[mid]==x:
        found=True
        break
    elif arr[mid] < x:
        l = mid + 1
    else:
        r = mid - 1
if found:
    print("found")
else:
    print("not found")
