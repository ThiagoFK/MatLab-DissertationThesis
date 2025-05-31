import numpy as np
import cv2
import os

# Open the video 

cap = cv2.VideoCapture('Teste135mm1Focus.mp4')

# Define the folder name
folder_name = "135mm1FocusExactly"

# Create the folder
try:
    os.mkdir(folder_name)
except Exception as e:
    print(f"An error occurred: {e}")


# Define the path to save the video

TO_PATH=folder_name

# Some characteristics from the original video
FRAME_WIDTH, FRAME_HEIGHT = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH)), int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
FPS, FRAMES = cap.get(cv2.CAP_PROP_FPS), cap.get(cv2.CAP_PROP_FRAME_COUNT)

# Defining croping values
FPS_RATIO = 5
INITIAL_TIME,FINAL_TIME=1,cap.get(cv2.CAP_PROP_FRAME_COUNT)
INITIAL_FRAME,FINAL_FRAME=FPS*INITIAL_TIME,FPS*FINAL_TIME

# Initializing frame counter
count = INITIAL_FRAME-1

# Now we start
try:
    while cap.isOpened() and count<=FINAL_FRAME:
        ret, frame = cap.read()
        count += 1 # Counting frames

        # Clause Guard
        if ret is False:
            break
        # Show Progress (only two first digits after period)
        progress_percentage = (count-INITIAL_FRAME) * 100/(FINAL_FRAME-INITIAL_FRAME)
        print(f"{progress_percentage:.2f}%")

        # Saving from the desired frames
        if count % FPS_RATIO == 0:

            rotated_frame = cv2.rotate(frame, cv2.ROTATE_90_CLOCKWISE)

            # Writing the file inside directory
            name=int(((count-INITIAL_FRAME)/FPS_RATIO))
            cv2.imwrite(f"{TO_PATH}/REF00_{name}.tif", rotated_frame)
            
	    # Setting quitting button as q
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
finally:
    cap.release()
    cv2.destroyAllWindows()