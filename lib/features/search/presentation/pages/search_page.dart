import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jungle_memos/components/user_tile.dart';
import 'package:jungle_memos/features/search/presentation/cubits/search_cubit.dart';
import 'package:jungle_memos/features/search/presentation/cubits/search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final TextEditingController searchController = TextEditingController();
  late final searchCubit = context.read<SearchCubit>();

  void onSearchChanged(){
    final query = searchController.text;
    searchCubit.searchUsers(query);
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

    // SCAFFOLD
    return Scaffold(

      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search Users",
            hintStyle: GoogleFonts.openSans(color: Theme.of(context).colorScheme.primary)
          ),
        ),
      ),

      body: BlocBuilder <SearchCubit, SearchState> (
        builder:(context, state) {

          // loaded
          if(state is SearchLoaded){
            
            // no users
            if(state.users.isEmpty){
              return const Center(child: Text("No users found"));
            }

            // users
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index){
                final singleUser = state.users[index];
                return UserTile(user: singleUser!);
              }
            );
          }

          // loading..
          else if(state is SearchLoading){
            return const Center(child: CircularProgressIndicator());
          }

          // error
          else if(state is SearchError){
            return Center(
              child: Text(state.message),
            );
          }

          // default
          else {
            return Center(
              child: Text(
                "Start Searching for Users",
                style: GoogleFonts.openSans(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 16),
              ),
            );
          }
        },
      ),
    );
  }
}