import qrcode

# Create QR code
img = qrcode.make(5)

# Save the image
img.save('qrcode.png')
