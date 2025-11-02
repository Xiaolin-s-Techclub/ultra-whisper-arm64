import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/settings.dart';
import '../services/app_service.dart';
import 'hotkey_recorder.dart';

class SettingsWindow extends StatefulWidget {
  const SettingsWindow({super.key});

  @override
  State<SettingsWindow> createState() => _SettingsWindowState();
}

class _SettingsWindowState extends State<SettingsWindow>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Settings _settings;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _settings = context.read<AppService>().settings;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      height: 500,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              const Text(
                'UltraWhisper Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tab bar
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(text: 'General'),
              Tab(text: 'Audio'),
              Tab(text: 'Model'),
              Tab(text: 'Language'),
              Tab(text: 'Shortcuts'),
              Tab(text: 'Appearance'),
              Tab(text: 'Advanced'),
            ],
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGeneralTab(),
                _buildAudioTab(),
                _buildModelTab(),
                _buildLanguageTab(),
                _buildShortcutsTab(),
                _buildAppearanceTab(),
                _buildAdvancedTab(),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Footer buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _saveSettings,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Default Action',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<PasteAction>(
            value: _settings.defaultAction,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _settings = _settings.copyWith(defaultAction: value);
                });
              }
            },
            items: PasteAction.values.map((action) {
              return DropdownMenuItem(
                value: action,
                child: Text(_pasteActionToString(action)),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Checkbox(
                value: _settings.aiHandoffEnabled,
                onChanged: (value) {
                  setState(() {
                    _settings = _settings.copyWith(
                      aiHandoffEnabled: value ?? false,
                    );
                  });
                },
              ),
              const Text('Enable AI Handoff'),
            ],
          ),

          if (_settings.aiHandoffEnabled) ...[
            const SizedBox(height: 16),
            const Text(
              'AI Handoff Sequence:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              children: _settings.aiHandoffSequence.asMap().entries.map((
                entry,
              ) {
                final index = entry.key;
                final keystroke = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text('${index + 1}. '),
                      Expanded(
                        child: TextFormField(
                          initialValue: keystroke,
                          onChanged: (value) {
                            final newSequence = List<String>.from(
                              _settings.aiHandoffSequence,
                            );
                            newSequence[index] = value;
                            setState(() {
                              _settings = _settings.copyWith(
                                aiHandoffSequence: newSequence,
                              );
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Delay between steps (ms): '),
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    initialValue: _settings.aiHandoffDelay.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final delay =
                          int.tryParse(value) ?? _settings.aiHandoffDelay;
                      setState(() {
                        _settings = _settings.copyWith(aiHandoffDelay: delay);
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAudioTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Input Device',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _settings.inputDevice,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _settings = _settings.copyWith(inputDevice: value);
                });
              }
            },
            items: const [
              DropdownMenuItem(
                value: 'default',
                child: Text('Built-in Microphone'),
              ),
              DropdownMenuItem(
                value: 'blackhole',
                child: Text('BlackHole 2ch'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              const Text('Sample Rate: '),
              SizedBox(
                width: 100,
                child: TextFormField(
                  initialValue: _settings.sampleRate.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final rate = int.tryParse(value) ?? _settings.sampleRate;
                    setState(() {
                      _settings = _settings.copyWith(sampleRate: rate);
                    });
                  },
                ),
              ),
              const Text(' Hz'),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const Text('Chunk Size: '),
              SizedBox(
                width: 100,
                child: TextFormField(
                  initialValue: _settings.chunkSizeMs.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final size = int.tryParse(value) ?? _settings.chunkSizeMs;
                    setState(() {
                      _settings = _settings.copyWith(chunkSizeMs: size);
                    });
                  },
                ),
              ),
              const Text(' ms'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModelTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Whisper Model',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<WhisperModel>(
            value: _settings.model,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _settings = _settings.copyWith(model: value);
                });
              }
            },
            items: WhisperModel.values.map((model) {
              return DropdownMenuItem(
                value: model,
                child: Text(_modelToString(model)),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          const Text(
            'Compute Device',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<ComputeDevice>(
            value: _settings.device,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _settings = _settings.copyWith(device: value);
                });
              }
            },
            items: ComputeDevice.values.map((device) {
              return DropdownMenuItem(
                value: device,
                child: Text(_deviceToString(device)),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          const Text(
            'Compute Type',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<ComputeType>(
            value: _settings.computeType,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _settings = _settings.copyWith(computeType: value);
                });
              }
            },
            items: ComputeType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(_computeTypeToString(type)),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          const Text(
            'Model Storage Path',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: _settings.modelStoragePath,
            readOnly: true,
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.folder_open),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: _settings.autoDetectLanguage,
                onChanged: (value) {
                  setState(() {
                    _settings = _settings.copyWith(
                      autoDetectLanguage: value ?? true,
                    );
                  });
                },
              ),
              const Text('Auto-detect Language'),
            ],
          ),

          if (!_settings.autoDetectLanguage) ...[
            const SizedBox(height: 16),
            const Text(
              'Manual Language Override',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<Language>(
              value: _settings.manualLanguage,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _settings = _settings.copyWith(manualLanguage: value);
                  });
                }
              },
              items: Language.values.map((lang) {
                return DropdownMenuItem(
                  value: lang,
                  child: Text(_languageToString(lang)),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShortcutsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHotkeyField('Hold-to-talk', _settings.holdToTalkHotkey, (
            value,
          ) {
            setState(() {
              _settings = _settings.copyWith(holdToTalkHotkey: value);
            });
          }),

          const SizedBox(height: 16),

          _buildHotkeyField('Toggle Record', _settings.toggleRecordHotkey, (
            value,
          ) {
            setState(() {
              _settings = _settings.copyWith(toggleRecordHotkey: value);
            });
          }),

          const SizedBox(height: 16),

          _buildHotkeyField(
            'Partial Text Peek (Hold)',
            _settings.partialTextPeekHotkey,
            (value) {
              setState(() {
                _settings = _settings.copyWith(partialTextPeekHotkey: value);
              });
            },
          ),

          const SizedBox(height: 16),

          _buildHotkeyField(
            'Partial Text Toggle',
            _settings.partialTextToggleHotkey,
            (value) {
              setState(() {
                _settings = _settings.copyWith(partialTextToggleHotkey: value);
              });
            },
          ),

          const SizedBox(height: 16),

          _buildHotkeyField(
            'AI Handoff Trigger',
            _settings.aiHandoffTriggerHotkey,
            (value) {
              setState(() {
                _settings = _settings.copyWith(aiHandoffTriggerHotkey: value);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Glass Effect',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          const Text('Glass Material Type'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _settings.glassEffect,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _settings = _settings.copyWith(glassEffect: value);
                });
              }
            },
            items: const [
              DropdownMenuItem(value: 'hudWindow', child: Text('HUD Window')),
              DropdownMenuItem(value: 'sidebar', child: Text('Sidebar')),
              DropdownMenuItem(value: 'menu', child: Text('Menu')),
              DropdownMenuItem(value: 'popover', child: Text('Popover')),
              DropdownMenuItem(value: 'titlebar', child: Text('Titlebar')),
            ],
          ),

          const SizedBox(height: 24),

          const Text('Blur Radius'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _settings.glassBlurRadius,
                  min: 0,
                  max: 50,
                  divisions: 50,
                  label: _settings.glassBlurRadius.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      _settings = _settings.copyWith(glassBlurRadius: value);
                    });
                  },
                ),
              ),
              SizedBox(
                width: 60,
                child: Text(
                  '${_settings.glassBlurRadius.round()}px',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text('Glass Opacity'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _settings.glassOpacity,
                  min: 0.0,
                  max: 1.0,
                  divisions: 100,
                  label: '${(_settings.glassOpacity * 100).round()}%',
                  onChanged: (value) {
                    setState(() {
                      _settings = _settings.copyWith(glassOpacity: value);
                    });
                  },
                ),
              ),
              SizedBox(
                width: 60,
                child: Text(
                  '${(_settings.glassOpacity * 100).round()}%',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text('Border Opacity'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _settings.borderOpacity,
                  min: 0.0,
                  max: 1.0,
                  divisions: 100,
                  label: '${(_settings.borderOpacity * 100).round()}%',
                  onChanged: (value) {
                    setState(() {
                      _settings = _settings.copyWith(borderOpacity: value);
                    });
                  },
                ),
              ),
              SizedBox(
                width: 60,
                child: Text(
                  '${(_settings.borderOpacity * 100).round()}%',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            'Window Behavior',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          CheckboxListTile(
            title: const Text('Always on Top'),
            subtitle: const Text('Keep window above other applications'),
            value: _settings.alwaysOnTop,
            onChanged: (value) {
              setState(() {
                _settings = _settings.copyWith(alwaysOnTop: value ?? false);
              });
            },
          ),

          CheckboxListTile(
            title: const Text('Bring to Front During Recording'),
            subtitle: const Text('Bring window to front when recording starts (may interfere with pasting)'),
            value: _settings.bringToFrontDuringRecording,
            onChanged: (value) {
              setState(() {
                _settings = _settings.copyWith(bringToFrontDuringRecording: value ?? false);
              });
            },
          ),

          const SizedBox(height: 16),

          const Text(
            'Overlay Size',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              const Text('Width: '),
              SizedBox(
                width: 100,
                child: TextFormField(
                  initialValue: _settings.overlayWidth.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final width =
                        double.tryParse(value) ?? _settings.overlayWidth;
                    setState(() {
                      _settings = _settings.copyWith(overlayWidth: width);
                    });
                  },
                ),
              ),
              const Text(' px'),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const Text('Height: '),
              SizedBox(
                width: 100,
                child: TextFormField(
                  initialValue: _settings.overlayHeight.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final height =
                        double.tryParse(value) ?? _settings.overlayHeight;
                    setState(() {
                      _settings = _settings.copyWith(overlayHeight: height);
                    });
                  },
                ),
              ),
              const Text(' px'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Logging Level',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _settings.loggingLevel,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _settings = _settings.copyWith(loggingLevel: value);
                });
              }
            },
            items: const [
              DropdownMenuItem(value: 'DEBUG', child: Text('Debug')),
              DropdownMenuItem(value: 'INFO', child: Text('Info')),
              DropdownMenuItem(value: 'WARNING', child: Text('Warning')),
              DropdownMenuItem(value: 'ERROR', child: Text('Error')),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            'Post-processing',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          CheckboxListTile(
            title: const Text('Smart Capitalization'),
            value: _settings.smartCapitalization,
            onChanged: (value) {
              setState(() {
                _settings = _settings.copyWith(
                  smartCapitalization: value ?? true,
                );
              });
            },
          ),

          CheckboxListTile(
            title: const Text('Punctuation'),
            value: _settings.punctuation,
            onChanged: (value) {
              setState(() {
                _settings = _settings.copyWith(punctuation: value ?? true);
              });
            },
          ),

          CheckboxListTile(
            title: const Text('Disfluency Cleanup'),
            value: _settings.disfluencyCleanup,
            onChanged: (value) {
              setState(() {
                _settings = _settings.copyWith(
                  disfluencyCleanup: value ?? true,
                );
              });
            },
          ),

          CheckboxListTile(
            title: const Text('Paste + Enter'),
            value: _settings.pasteWithEnter,
            onChanged: (value) {
              setState(() {
                _settings = _settings.copyWith(pasteWithEnter: value ?? false);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHotkeyField(
    String label,
    String value,
    ValueChanged<String> onChanged,
  ) {
    return HotkeyRecorder(
      label: label,
      initialValue: value,
      onChanged: onChanged,
    );
  }

  void _saveSettings() {
    context.read<AppService>().updateSettings(_settings);
    Navigator.of(context).pop();
  }

  String _pasteActionToString(PasteAction action) {
    switch (action) {
      case PasteAction.paste:
        return 'Paste';
      case PasteAction.pasteWithEnter:
        return 'Paste + Enter';
      case PasteAction.clipboardOnly:
        return 'Clipboard Only';
    }
  }

  String _modelToString(WhisperModel model) {
    switch (model) {
      case WhisperModel.small:
        return 'small';
      case WhisperModel.medium:
        return 'medium';
      case WhisperModel.large:
        return 'large';
      case WhisperModel.largeV3:
        return 'large-v3';
      case WhisperModel.largeV3Turbo:
        return 'large-v3-turbo';
    }
  }

  String _deviceToString(ComputeDevice device) {
    switch (device) {
      case ComputeDevice.auto:
        return 'Auto';
      case ComputeDevice.metal:
        return 'Metal (GPU)';
      case ComputeDevice.cpu:
        return 'CPU';
    }
  }

  String _computeTypeToString(ComputeType type) {
    switch (type) {
      case ComputeType.int8Float16:
        return 'int8_float16';
      case ComputeType.int8Float32:
        return 'int8_float32';
      case ComputeType.float16:
        return 'float16';
      case ComputeType.int8:
        return 'int8';
      case ComputeType.float32:
        return 'float32';
    }
  }

  String _languageToString(Language language) {
    switch (language) {
      case Language.auto:
        return 'Auto-detect';
      case Language.english:
        return 'English';
      case Language.japanese:
        return 'Japanese';
    }
  }
}
