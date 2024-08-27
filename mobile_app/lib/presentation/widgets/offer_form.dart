import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        children: [
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _discountPercentageController,
            decoration: InputDecoration(labelText: 'Discount Percentage'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a discount percentage';
              }
              final percentage = double.tryParse(value);
              if (percentage == null || percentage < 0 || percentage > 100) {
                return 'Please enter a valid percentage between 0 and 100';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _originalPriceController,
            decoration: InputDecoration(labelText: 'Original Price'),
            keyboardType: TextInputType.number,
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
          TextFormField(
            controller: _discountedPriceController,
            decoration: InputDecoration(labelText: 'Discounted Price'),
            keyboardType: TextInputType.number,
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
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
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
            },
            child: Text(widget.offer == null ? 'Create Offer' : 'Update Offer'),
          ),
        ],
      ),
    );
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