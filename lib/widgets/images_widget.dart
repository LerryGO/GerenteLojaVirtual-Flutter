import 'package:flutter/material.dart';
import 'package:gerente_loja/widgets/image_source_sheet.dart';

class ImagesWidget extends FormField<List> {
  ImagesWidget(
      {Key? key,
      BuildContext? context,
      FormFieldSetter<List>? onSaved,
      FormFieldValidator<List>? validator,
      List? initialValue,
      AutovalidateMode autoValidate = AutovalidateMode.disabled})
      : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidateMode: autoValidate,
            builder: (state) {
              return Column(
                
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 124,
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: state.value!.map<Widget>(
                        (i) {
                          return Container(
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              child: i is String
                                  ? Image.network(
                                      i,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(i, fit: BoxFit.cover),
                              onLongPress: () {
                                state.didChange(state.value!..remove(i));
                              },
                            ),
                          );
                        },
                      ).toList()
                        ..add(
                          GestureDetector(
                            child: Container(
                              height: 100,
                              width: 100,
                              child: const Icon(
                                Icons.camera_enhance,
                                color: Colors.white,
                              ),
                              color: Colors.white.withAlpha(50),
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                  context: context!,
                                  builder: (context) {
                                    return ImageSourceSheet(
                                      onImageSelected: (image) {
                                        state.didChange(state.value!..add(image));
                                      },
                                    );
                                  });
                            },
                          ),
                        ),
                    ),
                  ),
                  state.hasError
                      ? Text(
                          state.errorText!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        )
                      : Container(),
                ],
              );
            });
}
