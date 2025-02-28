import 'dart:io';

import 'package:chat/screens/home.dart';
import 'package:chat/widgets/category.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/lawyer.dart';
import '../models/account.dart';
import 'Lawyer screens/lawyerHomeScreen.dart';
import 'package:image_picker/image_picker.dart';

class New extends StatefulWidget {
  const New({super.key, required this.email, required this.uid});
  final String email;
  final String uid;

  @override
  State<New> createState() => _NewState();
}

class _NewState extends State<New> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  bool issLawyer = false;
  final List<String> professions = categories.map((e) => e.name).toList();
  String? _selectedProfession;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _licenseNoController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController provinceCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5EEDC),
        title: const Text(
          'Complete sign-up ',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Please select one:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSelectionButton("I'm a Client", Icons.person, false),
                  _buildSelectionButton("I'm a Lawyer", Icons.gavel, true),
                ],
              ),
              Center(
                child: GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : null,
                    child:
                        _selectedImage == null ? Icon(Icons.camera_alt) : null,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildUserFields(),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF5EEDC),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Form Submitted Successfully!')),
                    );
                  }

                  String imageUrl = "";
                  if (_selectedImage != null) {
                    try {
                      // Wait for the image to upload and get the URL
                      imageUrl = await uploadProfilePic(_selectedImage!);
                    } catch (e) {
                      // Handle any errors during the image upload
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error uploading image: $e')),
                      );
                      return; // Exit the function if image upload fails
                    }
                  }

                  setState(() {
                    if (!issLawyer) {
                      Account slipp = Account(
                          uid: widget.uid,
                          isLawyer: false,
                          name: _nameController.text,
                          email: widget.email,
                          number: _phoneNumberController.text);
                      slipp.addToFirestore();
                      Get.to(HomeScreen(account: slipp));
                    } else {
                      Lawyer jimmy = Lawyer(
                          uid: widget.uid,
                          name: _nameController.text,
                          email: widget.email,
                          number: _phoneNumberController.text,
                          licenseNO: _licenseNoController.text,
                          exp: int.parse(_experienceController.text),
                          province: provinceCont.text,
                          specialization: _selectedProfession,
                          isLawyer: issLawyer
                          //    pic: imageUrl.isNotEmpty ? imageUrl : "default_url_here",
                          );
                      jimmy.addToFirestore();
                      Get.to(LawyerHomeScreen(
                        lawyer: jimmy,
                      ));
                    }
                  });
                },
                child: const Center(
                  child: Text('Submit',
                      style: TextStyle(
                          fontSize: 18, color: Color.fromARGB(255, 0, 0, 0))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionButton(String text, IconData icon, bool isSelected) {
    bool selected = (issLawyer == isSelected);
    return GestureDetector(
      onTap: () => setState(() => issLawyer = isSelected),
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          color: selected ? Color(0xFFF5EEDC) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: selected ? Color(0xFFF5EEDC) : Colors.grey.shade400,
              width: 2),
          boxShadow: [
            if (selected) BoxShadow(color: Color(0xFFF5EEDC), blurRadius: 8)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: selected ? Colors.white : Colors.black),
            const SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField("Full name", _nameController),
        const SizedBox(height: 20),
        _buildInputField("Phone Number", _phoneNumberController),
        if (issLawyer) ...[
          const SizedBox(height: 20),
          _buildDropdownField(
              "Select Profession", _selectedProfession, professions, (val) {
            setState(() {
              _selectedProfession = val;
            });
          }),
          const SizedBox(height: 20),
          _buildInputField("Years of Experience", _experienceController,
              keyboardType: TextInputType.number),
          const SizedBox(height: 20),
          _buildInputField("License Number", _licenseNoController),
          const SizedBox(height: 20),
          _buildDropdownField("Province", null, [
            "Amman (capital)",
            "Zarqaa",
            "Irbid",
            "Aqaba",
            "Maan",
          ], (val) {
            setState(() {
              provinceCont.text = val.toString();
            });
          }),
        ],
      ],
    );
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource
            .gallery, // Change to ImageSource.camera if you want to pick from camera
        imageQuality: 80, // Adjust quality as needed
      );
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: "Enter $label",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'This field is required' : null,
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> items,
      Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
          hint: Text("Select $label"),
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
          validator: (value) =>
              value == null ? 'Please select an option' : null,
        ),
      ],
    );
  }
}

Future<String> uploadProfilePic(File image) async {
  String fileName = "lawyers/${DateTime.now().millisecondsSinceEpoch}.jpg";
  Reference ref = FirebaseStorage.instance.ref().child(fileName);
  UploadTask uploadTask = ref.putFile(image);
  TaskSnapshot snapshot = await uploadTask;
  return await snapshot.ref.getDownloadURL();
}
