// Example: Upload a file to Firebase Storage
async function uploadImage(file) {
    const storageRef = storage.ref(`profile_images/${file.name}`);
    await storageRef.put(file);
    const downloadUrl = await storageRef.getDownloadURL();
    console.log('File available at', downloadUrl);
    return downloadUrl;
  }
  
  // Example: Initialize an image upload
  document.getElementById('upload-button').addEventListener('click', async () => {
    const fileInput = document.getElementById('file-input');
    const file = fileInput.files[0];
    if (file) {
      const downloadUrl = await uploadImage(file);
      console.log('Uploaded image URL:', downloadUrl);
    }
  });