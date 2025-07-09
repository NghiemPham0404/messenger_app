import 'package:chatting_app/ui/view_models/theme_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Themes", style: TextStyle(fontSize: 20)),
            foregroundColor: Theme.of(context).primaryColor,
          ),
          body: Consumer<ThemeViewModel>(
            builder:
                (context, viewModel, child) => bodyBuild(context, viewModel),
          ),
        ),
      ),
    );
  }

  Widget bodyBuild(BuildContext context, ThemeViewModel themeViewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getColorPaletteConfigBar(context, themeViewModel),
        _getBrightModeConfigBar(context, themeViewModel),
      ],
    );
  }

  Widget _getColorPaletteConfigBar(
    BuildContext context,
    ThemeViewModel themeViewModel,
  ) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text("Color Palette", style: TextStyle(fontSize: 15)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 20,
              children: List.generate(
                themeViewModel.colorModels.length,
                (index) => SizedBox(
                  width: 32,
                  height: 32,
                  child: GestureDetector(
                    onTap: () => themeViewModel.saveSelectedThemeIndex(index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            themeViewModel.colorModels[index].primary,
                            themeViewModel.colorModels[index].primaryDark,
                          ],
                        ),
                      ),
                      child:
                          (index == themeViewModel.selectedIndex)
                              ? Icon(Icons.check)
                              : SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBrightModeConfigBar(
    BuildContext context,
    ThemeViewModel viewModel,
  ) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Bright Mode", style: TextStyle(fontSize: 15)),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed:
                    () =>
                        viewModel.currentBrightMode == Brightness.dark
                            ? null
                            : viewModel.saveSelectedBrightMode(Brightness.dark),
                style: TextButton.styleFrom(
                  foregroundColor:
                      viewModel.currentBrightMode == Brightness.dark
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.onSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.dark_mode, size: 32),
                    SizedBox(height: 4),
                    Text("Dark", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              TextButton(
                onPressed:
                    () =>
                        viewModel.currentBrightMode == null
                            ? null
                            : viewModel.saveSelectedBrightMode(null),
                style: TextButton.styleFrom(
                  foregroundColor:
                      viewModel.currentBrightMode == null
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.onSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.brightness_auto_outlined, size: 32),
                    SizedBox(height: 4),
                    Text("Auto", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              TextButton(
                onPressed:
                    () =>
                        viewModel.currentBrightMode == Brightness.light
                            ? null
                            : viewModel.saveSelectedBrightMode(
                              Brightness.light,
                            ),
                style: TextButton.styleFrom(
                  foregroundColor:
                      viewModel.currentBrightMode == Brightness.light
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.onSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.light_mode, size: 32),
                    SizedBox(height: 4),
                    Text("Bright", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
