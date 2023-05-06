import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'root_state.dart';

class RootCubit extends Cubit<RootState> {
  RootCubit()
      : super(RootState(
          user: null,
          errorMessage: '',
          loading: false,
        ));

  StreamSubscription? _streamSubscription;

  Future<void> start() async {
    emit(RootState(
      user: null,
      errorMessage: '',
      loading: false,
    ));

    _streamSubscription = FirebaseAuth.instance.authStateChanges().listen(
      (user) {
        emit(
          RootState(
            user: user,
            errorMessage: '',
            loading: false,
          ),
        );
      },
    )..onError(
        (error) {
          emit(
            RootState(
              user: null,
              errorMessage: error,
              loading: false,
            ),
          );
        },
      );
  }

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
