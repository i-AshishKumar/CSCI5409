import React, { useRef, useState, useCallback } from 'react';
import axios from 'axios';
import { Box, Button, Image, Modal, ModalOverlay, ModalContent, ModalHeader, ModalFooter, ModalBody, ModalCloseButton } from '@chakra-ui/react';
import Webcam from 'react-webcam';
import { useLocation } from 'react-router-dom';

import { useApiGateway } from '../context/ApiGatewayContext';



const CaptureUpload = ({ isOpen, onClose, onCapture }) => {
  const webcamRef = useRef(null);
  const [capturedImage, setCapturedImage] = useState(null);
  const [uploading, setUploading] = useState(false);

  const location = useLocation();
  const rekognitionId = location.state['rekognitionId'];

  const api_endpoint = `${useApiGateway()}dev/gallery`

  const capture = useCallback(() => {
    const imageSrc = webcamRef.current.getScreenshot();
    setCapturedImage(imageSrc);
  }, [webcamRef]);

  const retakePhoto = () => {
    setCapturedImage(null);
  };

  const handleUpload = async () => {
    setUploading(true);
    const base64Image = capturedImage.split(',')[1];

    const payload = JSON.stringify({
      body: {
        action: 'upload',
        rekognitionId: rekognitionId,
        file: base64Image,
        fileName: `captured_${Date.now()}.jpg`,
      }
    });

    await axios.post(api_endpoint, payload);

    setUploading(false);
    setCapturedImage(null);
    onCapture(); // Close the modal or reset capture state
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose}>
      <ModalOverlay />
      <ModalContent>
        <ModalHeader>{capturedImage ? 'Upload Image' : 'Take a Photo'}</ModalHeader>
        <ModalCloseButton />
        <ModalBody>
          {!capturedImage ? (
            <Box>
              <Webcam
                audio={false}
                ref={webcamRef}
                screenshotFormat="image/jpeg"
                screenshotQuality={1}
                width={250}
                height={250}
                style={{ alignSelf: 'center' }}
              />
              <Button onClick={capture} mt={4}>
                Capture
              </Button>
            </Box>
          ) : (
            <Box textAlign="center">
              <Image src={capturedImage} alt="Captured" height={250} width={250} />
              <Button onClick={handleUpload} isLoading={uploading} mt={4}>
                {uploading ? 'Uploading...' : 'Upload Photo'}
              </Button>
              <Button onClick={retakePhoto} mt={4} ml={2}>
                Retake Photo
              </Button>
            </Box>
          )}
        </ModalBody>
        <ModalFooter>
          <Button variant="ghost" onClick={onClose}>
            Close
          </Button>
        </ModalFooter>
      </ModalContent>
    </Modal>
  );
};

export default CaptureUpload;
