import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_poll_app/models/poll.dart';
import 'package:real_time_poll_app/screens/poll_screen.dart';
import 'package:real_time_poll_app/services/poll_service.dart';

class PollListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pollService = Provider.of<PollService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Polls'),
      ),
      body: StreamBuilder<List<Poll>>(
        stream: pollService.getPolls(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final polls = snapshot.data!;

          return ListView.builder(
            itemCount: polls.length,
            itemBuilder: (context, index) {
              final poll = polls[index];
              return ListTile(
                title: Text(poll.title),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PollScreen(poll: poll),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreatePollDialog(context, pollService);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreatePollDialog(BuildContext context, PollService pollService) {
    String title = '';
    List<String> options = ['', ''];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Poll'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(hintText: 'Poll Title'),
                  onChanged: (value) => title = value,
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(hintText: 'Option ${index + 1}'),
                              onChanged: (value) => options[index] = value,
                            ),
                          ),
                          if (index > 1)  // Remove option button
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                Navigator.pop(context); //close dialog to rebuild
                                options.removeAt(index);
                                _showCreatePollDialog(context, pollService);

                              },
                            ),
                        ],
                      ),
                    );
                  },
                ),
                TextButton( // Add option button
                  child: const Text('Add Option'),
                  onPressed: () {
                    Navigator.pop(context); //close dialog to rebuild
                    options.add('');
                    _showCreatePollDialog(context, pollService);
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Create'),
              onPressed: () {
                if (title.isNotEmpty && options.every((option) => option.isNotEmpty)) {
                  pollService.createPoll(title, options);
                  Navigator.of(context).pop();
                } else {
                  // Optionally show an error message if fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill in all fields.')));
                }
              },
            ),
          ],
        );
      },
    );
  }
}