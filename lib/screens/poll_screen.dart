import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_poll_app/models/poll.dart';
import 'package:real_time_poll_app/services/poll_service.dart';

class PollScreen extends StatelessWidget {
  final Poll poll;

  PollScreen({required this.poll});

  @override
  Widget build(BuildContext context) {
    final pollService = Provider.of<PollService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(poll.title),
      ),
      body: StreamBuilder<Poll>(
        stream: pollService.getPoll(poll.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final updatedPoll = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int i = 0; i < updatedPoll.options.length; i++) // Use updatedPoll here
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        pollService.vote(updatedPoll.id, i); //Use updatedPoll here
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(updatedPoll.options[i]), //Use updatedPoll here
                          Text('${updatedPoll.votes[i]} Votes'), //Use updatedPoll here
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}