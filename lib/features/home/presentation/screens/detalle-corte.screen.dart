import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_sig/config/blocs/auth/auth_bloc.dart';
import 'package:proyecto_sig/config/blocs/map/map_bloc.dart';
import 'package:proyecto_sig/config/constant/dialog.const.dart';
import 'package:proyecto_sig/config/services/media-handler-impl.service.dart';
import 'package:proyecto_sig/config/services/media-handler.service.dart';

class DetalleCorteScreen extends StatefulWidget {
  const DetalleCorteScreen({super.key});

  @override
  State<DetalleCorteScreen> createState() => _DetalleCorteScreenState();
}

class _DetalleCorteScreenState extends State<DetalleCorteScreen> {
  final MediaHandlerService _mediaHandler = MediaHandlerServiceImpl();
  String _imagePath = "";
  String estadoSeleccionado = 'Por Realizar';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authBloc = BlocProvider.of<AuthBloc>(context, listen: true);
    final mapBloc = BlocProvider.of<MapBloc>(context, listen: true);
    final corte = authBloc.state.infoCorte;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inspección de Servicio',
                    style: TextStyle(
                      fontSize: size.width * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'ID: ${corte?.bscocNcnt ?? ''}',
                    style: TextStyle(
                      fontSize: size.width * 0.035,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: size.height * 0.13,
              margin: EdgeInsets.symmetric(
                vertical: size.width * 0.04,
                horizontal: size.width * 0.04,
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildStatusCard(
                    size,
                    'Meses Pendientes',
                    '${corte?.bscocNmor ?? 0}',
                    Icons.calendar_today,
                  ),
                  SizedBox(width: size.width * 0.03),
                  _buildStatusCard(
                    size,
                    'Monto',
                    'Bs. ${corte?.bscocImor.toStringAsFixed(2) ?? 0}',
                    Icons.account_balance_wallet,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estado Actual',
                    style: TextStyle(
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(size.width * 0.03),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: estadoSeleccionado,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(size.width * 0.03),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: ['Por Realizar', 'Ejecutado'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              SizedBox(width: size.width * 0.02),
                              Text(value),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            estadoSeleccionado = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Evidencia Visual',
                        style: TextStyle(
                          fontSize: size.width * 0.045,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Capturamos el BuildContext en una función separada
                          Future<void> handleUpload(
                              BuildContext context) async {
                            String? imagePath = await _mediaHandler.takePhoto();
                            if (imagePath == null) return;

                            if (!context.mounted) return;

                            DialogService.showLoadingDialog(
                                context: context,
                                message: 'Subiendo imagen...');

                            try {
                              final imageUrl =
                                  await _mediaHandler.uploadImage(imagePath);

                              if (!context.mounted) return;

                              Navigator.pop(context);

                              if (imageUrl != null) {
                                setState(() {
                                  _imagePath = imageUrl;
                                });

                                DialogService.showSuccessSnackBar(
                                    "¡Imagen subida exitosamente!", context);
                              }
                            } catch (e) {
                              if (!context.mounted) return;

                              Navigator.pop(context);
                              DialogService.showErrorSnackBar(
                                  context: context,
                                  message: 'Error al subir la imagen: $e');
                            }
                          }

                          // Llamamos a la función con el context actual
                          await handleUpload(context);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.camera_alt, size: size.width * 0.045),
                            SizedBox(width: size.width * 0.01),
                            Text('Capturar'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.02),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(size.width * 0.03),
                      ),
                      child: _imagePath.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    size: size.width * 0.15,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  Text(
                                    'Sin evidencia',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: size.width * 0.04,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.03),
                              child: Image.network(
                                _imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: size.height * 0.02),
        child: FloatingActionButton.extended(
          onPressed: () {
            if (authBloc.state.infoCorteType == InfoCorteType.view) return;
            mapBloc.add(OnEditPuntoCorteRutaTrabajo(
                corte!, estadoSeleccionado, context));
          },
          backgroundColor: Colors.black,
          label: Row(
            children: [
              Icon(Icons.save, size: size.width * 0.05, color: Colors.white),
              SizedBox(width: size.width * 0.02),
              Text(
                'Guardar',
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildStatusCard(
      Size size, String title, String value, IconData icon) {
    return Container(
      width: size.width * 0.4,
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.width * 0.03),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: size.width * 0.06, color: Colors.black54),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: size.width * 0.035,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
