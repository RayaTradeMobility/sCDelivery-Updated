import 'package:RayaExpressDriver/Models/response_message_model.dart';
import 'package:RayaExpressDriver/Screens/MenuScreen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../API/API.dart';
import '../Models/get_driver_model.dart';

class TransferOrderScreen extends StatefulWidget {
  const TransferOrderScreen(
      {super.key,
      required this.fromShipmentNumber,
      required this.awbNumber,
      required this.driverUsername,
      required this.dUserID,
      required this.driverID});

  final String awbNumber;
  final int fromShipmentNumber;
  final String driverUsername, dUserID;
  final int driverID;

  @override
  State<TransferOrderScreen> createState() => _TransferOrderScreenState();
}

class _TransferOrderScreenState extends State<TransferOrderScreen> {
  API api = API();
  String? selectedValue;
  TextEditingController toShipmentNumberController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<String> items = [];
  Map<String?, String?> driverIdMap = {};
  String? selectedDriverId;

  Future<void> fetchDrivers() async {
    try {
      List<GetDriverModel> drivers = await api.getDriver();
      setState(() {
        items = drivers.map((driver) => driver.dName!).toList();
        driverIdMap = {
          for (var driver in drivers) driver.dName: driver.id.toString()
        };
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching drivers: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDrivers();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Order'),
      ),
      body: Column(
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Text(
                'Select Driver',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              value: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                  selectedDriverId = driverIdMap[value];
                });
              },
              buttonStyleData: ButtonStyleData(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 60,
                width: MediaQuery.of(context).size.width,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
              dropdownSearchData: DropdownSearchData(
                searchController: searchController,
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Container(
                  height: 50,
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 4,
                    right: 8,
                    left: 8,
                  ),
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    controller: searchController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: 'Search for Driver...',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  return item.value!
                      .toLowerCase()
                      .toString()
                      .contains(searchValue);
                },
              ),
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  searchController.clear();
                }
              },
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              if (kDebugMode) {
                print("order Id : ${widget.awbNumber}");
                print("fromShipmentNumber:  ${widget.fromShipmentNumber}");
                print("To Deliver id : $selectedDriverId");
              }
              selectedDriverId != null
                  ? AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      body: Column(
                        children: [
                          const Text("Enter Shipment Number"),
                          TextField(
                            controller: toShipmentNumberController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                          ),
                        ],
                      ),
                      btnOkColor: Colors.blue,
                      btnOkOnPress: () async {
                        if (toShipmentNumberController.text.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Please Enter a Shipment Number",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                        } else {
                          MessageResponse res = await api.transferOrder(
                            widget.awbNumber,
                            widget.fromShipmentNumber,
                            int.parse(selectedDriverId!),
                            int.parse(toShipmentNumberController.text),
                          );
                          toShipmentNumberController.clear();
                          if (res.message == "Success") {
                            Fluttertoast.showToast(
                              msg: res.message!,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            );
                            toShipmentNumberController
                                .clear(); // Clear the controller
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MenuScreen(
                                  driverUsername: widget.driverUsername,
                                  dUserID: widget.dUserID,
                                  driverID: widget.driverID,
                                ),
                              ),
                              (route) => false,
                            );
                          } else if (res.message != "Success" ||
                              res.message == null) {
                            Fluttertoast.showToast(
                              msg: res.message!,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            );
                            toShipmentNumberController
                                .clear(); // Clear the controller
                          }
                        }
                      },
                    ).show()
                  : Fluttertoast.showToast(
                      msg: "Please Choose Driver",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                    );
            },
            child: const Text("Confirm"),
          )
        ],
      ),
    );
  }
}
