// chat_bloc.dart
import 'dart:async';
import 'package:artificial_intelegence/Model/chat_message_model.dart';
import 'package:artificial_intelegence/repo/chat_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatSuccessState(messages: [])) {
    on<ChatGenerateNewTextMessageEvent>(chatGenerateNewTextMessageEvent);
  }

  List<ChatMessageModel> messages = [];
  bool generating = false;

  FutureOr<void> chatGenerateNewTextMessageEvent(
      ChatGenerateNewTextMessageEvent event, Emitter<ChatState> emit) async {
    if (event.inputMessage != null && event.inputMessage.isNotEmpty) {
      print('Received inputMessage: ${event.inputMessage}');
      messages.add(ChatMessageModel(
          role: "user", parts: [ChatPartModel(text: event.inputMessage)]));
      emit(ChatSuccessState(messages: messages));
      generating = true;
      String generatedText = await ChatRepo.chatTextGenerationRepo(messages);
      if (generatedText.isNotEmpty) {
        messages.add(ChatMessageModel(
            role: 'model', parts: [ChatPartModel(text: generatedText)]));
        emit(ChatSuccessState(messages: messages));
      }
      generating = false;
    } else {
      print('Received null or empty inputMessage');
      // Handle the case where inputMessage is null or empty
      // You can emit an error state or simply return
      return;
    }
  }
}