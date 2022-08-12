import 'package:bloc_example/apis/login_api.dart';
import 'package:bloc_example/apis/notes_api.dart';
import 'package:bloc_example/bloc/actions.dart';
import 'package:bloc_example/bloc/app_bloc.dart';
import 'package:bloc_example/bloc/app_state.dart';
import 'package:bloc_example/dialogs/generic_dialog.dart';
import 'package:bloc_example/dialogs/loading_screen.dart';
import 'package:bloc_example/models.dart';
import 'package:bloc_example/strings.dart';
import 'package:bloc_example/views/iterable_list_view.dart';
import 'package:bloc_example/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          builder: (context, state) {
            final notes = state.fetchNotes;
            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  context.read<AppBloc>().add(
                        LoginAction(
                          email: email,
                          password: password,
                        ),
                      );
                },
              );
            } else {
              return notes.toListView();
            }
          },
          listener: (context, state) {
            // loading screen
            if (state.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }

            // display possible errors
            final loginError = state.loginError;
            if (loginError != null) {
              showGenericDialog(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionBuilder: () => {ok: true},
              );
            }

            // if we are logged in, but we have no fetched notes, fetch them now
            if (state.isLoading == false &&
                state.loginError == null &&
                state.loginHandle == const LoginHandle.fooBar() &&
                state.fetchNotes == null) {
              context.read<AppBloc>().add(
                    const LoadNotesAction(),
                  );
            }
          },
        ),
      ),
    );
  }
}
