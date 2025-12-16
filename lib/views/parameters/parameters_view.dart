import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/widgets/components/thermometer.dart';
import 'package:acquariumfe/widgets/components/ph.dart';
import 'package:acquariumfe/widgets/components/salinity.dart';
import 'package:acquariumfe/widgets/components/orp.dart';
import 'package:acquariumfe/widgets/components/manual_parameters.dart';
import 'package:acquariumfe/providers/parameters_provider.dart';
import 'package:acquariumfe/widgets/responsive_builder.dart';
import 'package:acquariumfe/utils/responsive_breakpoints.dart';
import 'package:acquariumfe/l10n/app_localizations.dart';

class ParametersView extends ConsumerWidget {
  const ParametersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final parametersAsync = ref.watch(currentParametersProvider);
    final targetsAsync = ref.watch(targetParametersProvider);

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(currentParametersProvider.notifier).refresh();
        ref.invalidate(targetParametersProvider);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.parametersUpdated),
              duration: Duration(seconds: 2),
              backgroundColor: Color(0xFF34d399),
            ),
          );
        }
      },
      child: parametersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.circleExclamation,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text('${l10n.error}: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(currentParametersProvider.notifier).refresh(),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (currentParams) {
          if (currentParams == null) {
            return Center(child: Text(l10n.noParametersAvailable));
          }

          final targetParams = targetsAsync.when(
            data: (targets) => targets,
            loading: () => <String, double>{},
            error: (_, __) => <String, double>{},
          );

          return ResponsiveBuilder(
            builder: (context, info) {
              final padding = ResponsiveBreakpoints.horizontalPadding(
                info.screenWidth,
              );

              // Widget list
              final parameterWidgets = [
                Thermometer(
                  currentTemperature: currentParams.temperature,
                  targetTemperature: targetParams['temperature'] ?? 25.0,
                ),
                PhMeter(
                  currentPh: currentParams.ph,
                  targetPh: targetParams['ph'] ?? 8.2,
                ),
                SalinityMeter(
                  currentSalinity: currentParams.salinity,
                  targetSalinity: targetParams['salinity'] ?? 1.025,
                ),
                OrpMeter(
                  currentOrp: currentParams.orp,
                  targetOrp: targetParams['orp'] ?? 350.0,
                ),
              ];

              // Mobile: layout verticale
              if (info.isMobile) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    children: [
                      ...parameterWidgets.map(
                        (w) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: w,
                        ),
                      ),
                      const ManualParametersWidget(),
                    ],
                  ),
                );
              }

              // Tablet/Desktop: layout a griglia 2 colonne
              return SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: Column(
                  children: [
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: info.value(
                        mobile: 1.0,
                        tablet: 1.5,
                        desktop: 2.0,
                      ),
                      children: parameterWidgets,
                    ),
                    const SizedBox(height: 16),
                    const ManualParametersWidget(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
