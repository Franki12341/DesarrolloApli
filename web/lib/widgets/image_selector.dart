import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:examen01/config/images_config.dart';

class ImageSelector extends StatefulWidget {
  final List<String> selectedImages;
  final Function(List<String>) onImagesSelected;

  const ImageSelector({
    super.key,
    required this.selectedImages,
    required this.onImagesSelected,
  });

  @override
  State<ImageSelector> createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  List<String> _selectedImages = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedImages = List.from(widget.selectedImages);
  }

  void _toggleImage(String imageName) {
    setState(() {
      if (_selectedImages.contains(imageName)) {
        _selectedImages.remove(imageName);
      } else {
        _selectedImages.add(imageName);
      }
    });
    widget.onImagesSelected(_selectedImages);
  }

  List<String> get _filteredImages {
    if (_searchQuery.isEmpty) {
      return ImagesConfig.imageNames;
    }
    return ImagesConfig.searchByKeyword(_searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Seleccionar Imágenes del Terno',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Buscador
        TextField(
          decoration: InputDecoration(
            hintText: 'Buscar por color, estilo...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        const SizedBox(height: 8),

        if (_selectedImages.isNotEmpty)
          Text(
            '${_selectedImages.length} imagen(es) seleccionada(s)',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        const SizedBox(height: 12),

        // Lista de imágenes
        SizedBox(
          height: 140,
          child: _filteredImages.isEmpty
              ? Center(
                  child: Text(
                    'No se encontraron resultados',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filteredImages.length,
                  itemBuilder: (context, index) {
                    final imageName = _filteredImages[index];
                    final isSelected = _selectedImages.contains(imageName);
                    final imageUrl = ImagesConfig.getImageUrl(imageName);

                    return GestureDetector(
                      onTap: () => _toggleImage(imageName),
                      child: Container(
                        width: 110,
                        margin: const EdgeInsets.only(right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.deepPurple
                                      : Colors.grey,
                                  width: isSelected ? 3 : 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      width: 110,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color: Colors.grey[300],
                                        child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.checkroom,
                                                color: Colors.grey, size: 30),
                                            SizedBox(height: 4),
                                            Text(
                                              'Error',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.deepPurple,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              imageName,
                              style: const TextStyle(fontSize: 10),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
