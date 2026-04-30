import cv2
import numpy as np

img = cv2.imread("testimg.png")
img = img[:, :, [2, 1, 0]]
img = img[:, :, 0]

kernelx = np.array([[-1, 0, 1],
                    [-2, 0, 2],
                    [-1, 0, 1]])
kernely = np.array([[-1, -2, -1],
           [0, 0, 0],
           [1, 2, 1]])

# gx = cv2.filter2D(img, -1, kernel=kernelx)
# gy = cv2.filter2D(img, -1, kernel=kernely)

gradx = np.zeros((img.shape[0] - 2, img.shape[1] - 2))
grady = np.zeros((img.shape[0] - 2, img.shape[1] - 2))

for row in range(1, img.shape[0] - 1):
    for col in range(1, img.shape[1] - 1):
        window = img[row - 1 : row + 2, col - 1 : col + 2]
        weighted_context_x = window.astype(float) * kernelx.astype(float)
        weighted_context_y = window.astype(float) * kernely.astype(float)

        gx = weighted_context_x.sum().sum()
        gy = weighted_context_y.sum().sum()
        gradx[row - 1, col - 1] = gx
        grady[row - 1, col - 1] = gy

grad = np.abs(gradx) + np.abs(grady)
cv2.imshow("grad", (grad/np.max(grad) * 255).astype(np.uint8))
cv2.waitKey(0)
cv2.destroyAllWindows()