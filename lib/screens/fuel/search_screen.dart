import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fueler_new/services/firebase_firestore_services.dart';
import 'package:fueler_new/models/fuel_model.dart';
import 'package:fueler_new/views/fuel_cell_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode _focus = FocusNode();
  final _controller = TextEditingController();
  late Future _futureList;
  var showResult = false;

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var searchText = "";
    final language = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: Text(language.searchFuels),
      ),
      body: Column(
        children: [
          TapRegion(
          onTapOutside: (event) {
            _focus.unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18, top: 12),
            child: SizedBox(
              height: 48,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: _focus,
                      controller: _controller,
                      autofocus: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        hintText: language.searchHint,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                        suffixIcon: _controller.text.isNotEmpty ? IconButton(onPressed: () {
                          setState(() {
                            _controller.clear();
                            showResult = false;
                          });
                        }, icon: const Icon(Icons.clear),) : null,
                      ),     
                      onChanged: (value) {
                        setState(() {});
                      },
                      onSubmitted: (value) {
                        searchText = value;
                        var userUid = FirebaseAuth.instance.currentUser!.uid;
                        _futureList = FirebaseFirestoreServices().getFuelsByNameOrId(userUid,searchText);
                        setState(() {
                          showResult = true;
                        });

                      },
                    ),
                  ),
                  if(_focus.hasFocus)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: TextButton(onPressed: (){
                      _controller.clear();
                      _focus.unfocus();
                    }, child: Text(language.cancel)),
                  )
                ],
              ),
            ),
          ),
        ),
        if(showResult)
        FutureBuilder(future: _futureList, builder:(context, snapshot) {
          if(snapshot.hasData) {
            
            var fuels = snapshot.data as List<Fuel>;
            if(fuels.isEmpty) {
              return  Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child:  Center(child: Text(language.noFuelWasFound),),
              );
            }
            return Expanded(
              child: ListView.builder(
                itemCount: fuels.length,
                itemBuilder:(context, index) {
                return FuelCell(fuel: fuels[index]);
              },),
            );
          }
          return Container();
          
        },)


        ],
      ),
    );
  }
}