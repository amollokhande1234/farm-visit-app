import 'package:feild_visit_app/core/utils/snack_bar.dart';
import 'package:feild_visit_app/core/widgets/custom_button.dart';
import 'package:feild_visit_app/core/widgets/custom_text_feild.dart';
import 'package:feild_visit_app/core/widgets/feild_text.dart';
import 'package:feild_visit_app/features/home/bloc/add_visit/add_visit_cubit.dart';
import 'package:feild_visit_app/features/home/bloc/add_visit/add_visit_state.dart';
import 'package:feild_visit_app/features/home/bloc/location/location_cubit.dart';
import 'package:feild_visit_app/features/home/bloc/location/location_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../consts/hive_new_visit_model.dart';
import '../bloc/visit/visit_cubit.dart';

class AddVisitScreen extends StatefulWidget {
  const AddVisitScreen({super.key});

  @override
  State<AddVisitScreen> createState() => _AddVisitScreenState();
}

class _AddVisitScreenState extends State<AddVisitScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  File? _image;

  String lat = "";
  String long = "";

  final List<String> _crops = ['Wheat', 'Rice', 'Corn', 'Other'];

  String? _selectedCrop;

  Future<void> _pickImage() async {
    try {
      if (await Permission.camera.request().isGranted) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          maxWidth: 800,
          maxHeight: 800,
        );

        if (pickedFile != null) {
          setState(() => _image = File(pickedFile.path));
        }
      } else {
        showCustomSnackBar(context, 'Camera Permission Denied');
      }
    } catch (e) {
      showCustomSnackBar(context, 'Exception : ${e}');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _noteController.dispose();
    _villageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Visit',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FeildTextWidget('Farmer Name'),
                const SizedBox(height: 10),
                customTextField(
                  controller: _nameController,
                  hintText: 'Enter Name here',
                ),

                const SizedBox(height: 20),

                FeildTextWidget('Village'),
                const SizedBox(height: 10),
                customTextField(
                  controller: _villageController,
                  hintText: 'Enter Village here',
                ),

                const SizedBox(height: 20),
                FeildTextWidget('Note'),
                const SizedBox(height: 10),
                customTextField(
                  maxLines: 4,
                  controller: _noteController,
                  hintText: 'Enter note here ...',
                ),

                const SizedBox(height: 20),

                BlocConsumer<LocationCubit, LocationState>(
                  listener: (context, state) {
                    if (state is LocationError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    bool hasLocation = false;
                    String address = "Location not set";

                    if (state is LocationLoaded) {
                      hasLocation = true;
                      address = state.address;

                      lat = state.position.latitude.toString();
                      long = state.position.longitude.toString();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    context
                                        .read<LocationCubit>()
                                        .fetchLocation();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: hasLocation
                                          ? Colors.white
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 18,
                                          color: hasLocation
                                              ? Colors.green.shade700
                                              : Colors.grey.shade700,
                                        ),
                                        const SizedBox(width: 6),
                                        state is LocationLoading
                                            ? CupertinoActivityIndicator()
                                            : Text(
                                                hasLocation
                                                    ? "Location Set"
                                                    : "Set Location",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: hasLocation
                                                      ? Colors.green.shade800
                                                      : Colors.grey,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Container(
                                  height: 45, // fixed height
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedCrop,
                                      hint: const Text(
                                        "Select Crop",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      isExpanded: true,
                                      items: _crops.map((crop) {
                                        return DropdownMenuItem<String>(
                                          value: crop,
                                          child: Text(
                                            crop,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedCrop = newValue;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        if (hasLocation) ...[
                          Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "📍 Address:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  address,
                                  style: TextStyle(
                                    color: Colors.green.shade900,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Latitude: $lat",
                                  style: const TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "Longitude: $long",
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),

                const SizedBox(height: 10),

                const SizedBox(height: 20),
                const Text(
                  'Visit Photo',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey.shade200,
                    ),
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(_image!, fit: BoxFit.cover),
                          )
                        : const Center(
                            child: Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 30),

                BlocConsumer<AddVisitCubit, AddVisitState>(
                  listener: (context, state) {
                    if (state is AddVisitLoading) {
                      showCustomSnackBar(context, "Saving visit...");
                    }

                    if (state is AddVisitLoaded) {
                      _nameController.clear;
                      _noteController.clear;
                      _villageController.clear;

                      Navigator.of(context).pop();
                      showCustomSnackBar(
                        context,
                        "Visit Added Successfully",
                        backgroundColor: Colors.green,
                      );
                    }

                    if (state is AddVisitFailure) {
                      showCustomSnackBar(
                        context,
                        state.message,
                        backgroundColor: Colors.redAccent,
                      );
                    }
                  },
                  builder: (context, state) {
                    return customButton(
                      text: state is AddVisitLoading
                          ? 'Saving...'
                          : 'Add Visit',
                      onPressed: () {
                        /// ✅ VALIDATION FIRST
                        if (_nameController.text.isEmpty ||
                            _villageController.text.isEmpty) {
                          showCustomSnackBar(
                            context,
                            'Name,  Village required',
                            backgroundColor: Colors.redAccent,
                          );
                          return;
                        }

                        if (_image == null) {
                          showCustomSnackBar(
                            context,
                            'Crop Image Required',
                            backgroundColor: Colors.redAccent,
                          );
                          return;
                        }

                        final visit = VisitModel(
                          farmerName: _nameController.text,
                          villageName: _villageController.text,
                          note: _noteController.text,
                          time: DateTime.now(),
                          latitude: double.tryParse(lat),
                          longitude: double.tryParse(long),
                          cropType: _selectedCrop ?? 'Other',
                          isSynced: true,
                        );

                        context.read<AddVisitCubit>().addVisit(visit, _image!);
                        context.read<VisitCubit>().fetchAllVisits();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
