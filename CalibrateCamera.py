import numpy as np
import cv2 as cv
import glob

# Define Constants
WIDTH_N=24
LENGTH_N=23
 
# termination criteria
criteria = (cv.TERM_CRITERIA_EPS + cv.TERM_CRITERIA_MAX_ITER, 30, 0.001)
 
# prepare object points, like (0,0,0), (1,0,0), (2,0,0) ....,(6,5,0)
objp = np.zeros((WIDTH_N*LENGTH_N,3), np.float32)
objp[:,:2] = np.mgrid[0:WIDTH_N,0:LENGTH_N].T.reshape(-1,2)*5
 
# Arrays to store object points and image points from all the images.
objpoints = [] # 3d point in real world space
imgpoints = [] # 2d points in image plane.
 
# Define the path to the directory (use raw string to avoid issues with backslashes)
directory = r'T:\Tese Mestrado\calibration_images\135mm1Focus\*.tif'

images = glob.glob(directory)
 
for fname in images:
    img = cv.imread(fname)
    gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
 
    # Find the chess board corners
    ret, corners = cv.findChessboardCorners(gray, (WIDTH_N,LENGTH_N), None)
 
    # If found, add object points, image points (after refining them)
    if ret == True:
        objpoints.append(objp)
 
        corners2 = cv.cornerSubPix(gray,corners, (11,11), (-1,-1), criteria)
        imgpoints.append(corners2)
 
        # Draw and display the corners
        cv.drawChessboardCorners(img, (WIDTH_N,LENGTH_N), corners2, ret)
        cv.imshow('img', img)
        cv.waitKey(20)
 
cv.destroyAllWindows()

# Perform camera calibration
ret, camera_matrix, dist_coeffs, rvecs, tvecs = cv.calibrateCamera(objpoints, imgpoints, gray.shape[::-1], None, None)

# Output camera matrix and distortion coefficients
print("Camera Matrix:\n", camera_matrix)
print("Distortion Coefficients:\n", dist_coeffs)
print(f"Rotation Vector:\n{rvecs}")
print(f"Translation Vector (t):\n{tvecs}\n")

mean_error = 0
for i in range(len(objpoints)):
    imgpoints2, _ = cv.projectPoints(objpoints[i], rvecs[i], tvecs[i], camera_matrix, dist_coeffs)
    error = cv.norm(imgpoints[i], imgpoints2, cv.NORM_L2)/len(imgpoints2)
    mean_error += error
 
print( "Total error: {}".format(mean_error/len(objpoints)) )

# Creating a random pattern image
img=(np.random.rand(1920, 1080)*255).astype(np.uint8)
cv.imshow('Stochastic',img)
h, w = img.shape[:2]
new_camera_matrix, roi = cv.getOptimalNewCameraMatrix(camera_matrix, dist_coeffs, (w,h), 1, (w,h))

# Undistort the image
undistorted_img = cv.undistort(img, camera_matrix, dist_coeffs, None, new_camera_matrix)

# Save the undistorted image
cv.imwrite('0.jpg', img)
cv.imwrite('1.jpg', undistorted_img)