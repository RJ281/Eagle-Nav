import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _openDialer(BuildContext context, String number) async {
  final uri = Uri(scheme: 'tel', path: number.replaceAll(RegExp(r'[^0-9+]'), ''));
  bool launched;
  try {
    launched = await launchUrl(uri);
  } catch (_) {
    launched = false;
  }
  if (!launched && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Could not open the phone dialer. Please call $number.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

class EmergencyTab extends StatelessWidget {
  const EmergencyTab({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.red.shade700,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 4,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      const Icon(Icons.shield, color: Color(0xFFC9A227), size: 64),
                      const SizedBox(height: 20),
                      const Text(
                        'Emergency',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cal State LA Campus Safety',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 48),

                      ElevatedButton.icon(
                        style: buttonStyle,
                        icon: const Icon(Icons.emergency, size: 28),
                        label: const Text(
                          'Call 911',
                          semanticsLabel: 'Call 911',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => _openDialer(context, '911'),
                      ),

                      const SizedBox(height: 16),

                      ElevatedButton.icon(
                        style: buttonStyle,
                        icon: const Icon(Icons.phone, size: 28),
                        label: const Text(
                          'Call Campus Security',
                          semanticsLabel: 'Call Campus Security, (323) 343-3700',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => _openDialer(context, '(323) 343-3700'),
                      ),

                      const SizedBox(height: 20),

                      // Non-emergency info box
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Campus Safety Numbers',
                              style: TextStyle(
                                color: Color(0xFFC9A227),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            _InfoRow(icon: Icons.local_police, label: 'Campus Police', value: '(323) 343-3700'),
                            _InfoRow(icon: Icons.medical_services, label: 'Health Center', value: '(323) 343-3300'),
                            _InfoRow(icon: Icons.support_agent, label: 'Crisis Line', value: '(800) 854-7771'),
                          ],
                        ),
                      ),

                      const Spacer(),
                      const SizedBox(height: 16),

                      Text(
                        'In a life-threatening emergency, always call 911 first.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    void call() => _openDialer(context, value);

    return Semantics(
      button: true,
      label: 'Call $label, $value',
      onTap: call,
      excludeSemantics: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: call,
          borderRadius: BorderRadius.circular(8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
            child: Row(
              children: [
                Icon(icon, color: Colors.white54, size: 18),
                const SizedBox(width: 10),
                Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                const Spacer(),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
