import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:crypto/crypto.dart'; // Add this import for generating signatures
import '../../../utils/constants/api_constant.dart';

class CloudinaryService extends GetxController {
  static CloudinaryService get instance => Get.find();

  final String _cloudName = 'ddyyx7hl3';
  final String _uploadPreset = 'Ceyloan';
  final String _apiKey = APIConstants.tSecretAPIKey;
  final String _apiSecret = APIConstants.tSecretKey; // Add this line with your API secret

  // Base URL for Cloudinary upload
  String get _uploadUrl => 'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';

  /// Upload an image file to Cloudinary
  Future<String> uploadImage(File imageFile) async {
    try {
      if (kDebugMode) {
        print('Starting Cloudinary upload process');
        print('File exists: ${imageFile.existsSync()}');
        print('File path: ${imageFile.path}');
        print('File size: ${await imageFile.length()} bytes');
      }

      // Get the MIME type of the file
      final mimeTypeData = lookupMimeType(imageFile.path)?.split('/');
      final imageExtension = mimeTypeData != null ? mimeTypeData[1] : 'jpeg';

      if (kDebugMode) {
        print('MIME type: ${mimeTypeData?.join("/")}');
        print('Image extension: $imageExtension');
      }

      // Generate timestamp for signature
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Create signature if using signed uploads
      // String signature = generateSignature(timestamp.toString());

      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));

      if (kDebugMode) {
        print('Creating request to: $_uploadUrl');
      }

      // Add necessary parameters
      request.fields['upload_preset'] = _uploadPreset; // Using unsigned upload
      request.fields['api_key'] = _apiKey;
      request.fields['timestamp'] = timestamp.toString();

      if (kDebugMode) {
        print('Added fields: upload_preset=$_uploadPreset, timestamp=$timestamp');
      }

      // Add file to upload
      final multipartFile = await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType('image', imageExtension),
        filename: path.basename(imageFile.path),
      );

      request.files.add(multipartFile);

      if (kDebugMode) {
        print('Added file to request: ${multipartFile.filename}');
        print('Sending request to Cloudinary...');
      }

      // Send request
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw 'Request timed out after 30 seconds';
        },
      );

      if (kDebugMode) {
        print('Response received with status code: ${streamedResponse.statusCode}');
      }

      // Get response body
      final responseData = await streamedResponse.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);

      if (kDebugMode) {
        print('Response body: $responseString');
      }

      // Check if upload was successful
      if (streamedResponse.statusCode == 200) {
        final jsonData = json.decode(responseString);
        final secureUrl = jsonData['secure_url'];

        if (kDebugMode) {
          print('Upload successful! Secure URL: $secureUrl');
        }

        // Return the URL from the response
        return secureUrl;
      } else {
        if (kDebugMode) {
          print('Upload failed with status code: ${streamedResponse.statusCode}');
          print('Response body: $responseString');
        }
        throw 'Failed to upload image. Status code: ${streamedResponse.statusCode}';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception during image upload: $e');
      }
      throw 'Failed to upload image: $e';
    }
  }

  /// Generate signature for Cloudinary API request
  String generateSignature(String timestamp) {
    if (_apiSecret.isEmpty) {
      throw 'API Secret is required for generating signatures';
    }

    // Create parameters string to sign
    final paramsToSign = 'timestamp=$timestamp$_apiSecret';

    // Generate SHA-1 hash
    final bytes = utf8.encode(paramsToSign);
    final digest = sha1.convert(bytes);

    return digest.toString();
  }

  /// Delete an image from Cloudinary using its public ID
  Future<bool> deleteImage(String imageUrl) async {
    try {
      // Extract public ID from URL
      final publicId = getPublicIdFromUrl(imageUrl);

      if (publicId.isEmpty) {
        if (kDebugMode) {
          print('Failed to extract public ID from URL: $imageUrl');
        }
        return false;
      }

      if (kDebugMode) {
        print('Deleting image with public ID: $publicId');
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Generate signature for deletion
      final signature = generateSignature(timestamp.toString());

      // Create the URL for deleting resources
      final deleteUrl = 'https://api.cloudinary.com/v1_1/$_cloudName/image/destroy';

      // Send delete request
      final response = await http.post(
        Uri.parse(deleteUrl),
        body: {
          'public_id': publicId,
          'api_key': _apiKey,
          'timestamp': timestamp.toString(),
          'signature': signature,
        },
      );

      if (kDebugMode) {
        print('Delete response status: ${response.statusCode}');
        print('Delete response body: ${response.body}');
      }

      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting image: $e');
      }
      return false;
    }
  }

  /// Extract public ID from Cloudinary URL
  String getPublicIdFromUrl(String url) {
    try {
      // Format: https://res.cloudinary.com/{cloud_name}/image/upload/v{version}/{public_id}.{format}
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;

      if (kDebugMode) {
        print('Extracting public ID from URL: $url');
        print('Path segments: $pathSegments');
      }

      // Find the upload segment index
      final uploadIndex = pathSegments.indexOf('upload');

      if (uploadIndex >= 0 && uploadIndex + 1 < pathSegments.length) {
        // Skip the version segment (starts with 'v')
        int startIndex = uploadIndex + 1;
        if (pathSegments[startIndex].startsWith('v')) {
          startIndex++;
        }

        // The remaining path is the public ID (might include folders)
        final publicIdWithExtension = pathSegments.sublist(startIndex).join('/');

        // Remove file extension if present
        final lastDotIndex = publicIdWithExtension.lastIndexOf('.');
        final publicId = lastDotIndex > 0 ? publicIdWithExtension.substring(0, lastDotIndex) : publicIdWithExtension;

        if (kDebugMode) {
          print('Extracted public ID: $publicId');
        }

        return publicId;
      }

      if (kDebugMode) {
        print('Could not extract public ID from URL structure');
      }
      return '';
    } catch (e) {
      if (kDebugMode) {
        print('Error extracting public ID: $e');
      }
      return '';
    }
  }
}
