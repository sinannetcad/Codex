import 'package:flutter/material.dart';

import '../models/auth_response.dart';
import '../models/user_profile.dart';
import '../services/dating_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.api});

  final DatingApi api;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthResponse? _session;
  List<UserProfile> _profiles = [];
  int _index = 0;
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final session = await widget.api.register(
        name: 'Demo Kullanici',
        age: 28,
        bio: 'Yeni insanlarla tanismayi seviyorum.',
        avatarUrl: 'https://picsum.photos/seed/demo/300',
        email: 'demo@tinderclone.com',
        password: 'password',
      );

      final profiles = await widget.api.fetchProfiles(session.userId);

      setState(() {
        _session = session;
        _profiles = profiles;
        _index = 0;
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _handleSwipe(bool liked) async {
    if (_session == null || _index >= _profiles.length) {
      return;
    }

    final current = _profiles[_index];
    try {
      await widget.api.swipe(
        fromUserId: _session!.userId,
        toUserId: current.id,
        liked: liked,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Swipe hatasi: $error')),
      );
    }

    setState(() {
      _index += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tinder Clone')),
        body: Center(
          child: Text(_errorMessage ?? 'Bilinmeyen hata'),
        ),
      );
    }

    final hasProfiles = _index < _profiles.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tinder Clone'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: hasProfiles
            ? Column(
                children: [
                  Expanded(child: _ProfileCard(profile: _profiles[_index])),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _handleSwipe(false),
                          child: const Text('Pas'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _handleSwipe(true),
                          child: const Text('Like'),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : const Center(
                child: Text('Yeni profil kalmadi!'),
              ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                profile.avatarUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${profile.name}, ${profile.age}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(profile.bio),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: profile.interests
                      .map(
                        (interest) => Chip(label: Text(interest)),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
