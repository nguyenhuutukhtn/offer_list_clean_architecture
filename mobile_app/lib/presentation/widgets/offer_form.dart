import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/presentation/bloc/offer_event.dart';
import '../../domain/entities/offer.dart';
import '../bloc/offer_bloc.dart';

class OfferForm extends StatefulWidget {
  final Offer? offer;

  const OfferForm({Key? key, this.offer}) : super(key: key);

  @override
  _OfferFormState createState() => _OfferFormState();
}

class _OfferFormState extends State<OfferForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _discountPercentageController;
  late TextEditingController _originalPriceController;
  late TextEditingController _discountedPriceController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.offer?.title ?? '');
    _descriptionController = TextEditingController(text: widget.offer?.description ?? '');
    _discountPercentageController = TextEditingController(text: widget.offer?.discountPercentage.toString() ?? '');
    _originalPriceController = TextEditingController(text: widget.offer?.originalPrice.toString() ?? '');
    _discountedPriceController = TextEditingController(text: widget.offer?.discountedPrice.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
    
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.offer == null ? 'Create New Offer' : 'Edit Offer',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          _buildTextField(
            controller: _titleController,
            label: 'Title',
            icon: Icons.title,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: _descriptionController,
            label: 'Description',
            icon: Icons.description,
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: _discountPercentageController,
            label: 'Discount Percentage',
            icon: Icons.percent,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a discount percentage';
              }
              final percentage = int.tryParse(value);
              if (percentage == null || percentage < 0 || percentage > 100) {
                return 'Please enter a valid percentage between 0 and 100';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: _originalPriceController,
            label: 'Original Price',
            icon: Icons.attach_money,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an original price';
              }
              final price = double.tryParse(value);
              if (price == null || price <= 0) {
                return 'Please enter a valid price greater than 0';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: _discountedPriceController,
            label: 'Discounted Price',
            icon: Icons.local_offer,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a discounted price';
              }
              final discountedPrice = double.tryParse(value);
              final originalPrice = double.tryParse(_originalPriceController.text);
              if (discountedPrice == null || discountedPrice <= 0 || originalPrice == null || discountedPrice >= originalPrice) {
                return 'Please enter a valid discounted price (greater than 0 and less than the original price)';
              }
              return null;
            },
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text(widget.offer == null ? 'Create Offer' : 'Update Offer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final offer = Offer(
        id: widget.offer?.id ?? '',
        title: _titleController.text,
        description: _descriptionController.text,
        discountPercentage: double.parse(_discountPercentageController.text),
        originalPrice: double.parse(_originalPriceController.text),
        discountedPrice: double.parse(_discountedPriceController.text),
      );

      if (widget.offer == null) {
        BlocProvider.of<OfferBloc>(context).add(CreateOfferEvent(offer));
      } else {
        BlocProvider.of<OfferBloc>(context).add(UpdateOfferEvent(offer));
      }

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _discountPercentageController.dispose();
    _originalPriceController.dispose();
    _discountedPriceController.dispose();
    super.dispose();
  }
}