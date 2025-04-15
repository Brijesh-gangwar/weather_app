import 'package:flutter/material.dart';

class CitySearchBar extends StatefulWidget {
  final String currentCity;
  final Function(String) onSearch;

  const CitySearchBar({
    Key? key,
    required this.currentCity,
    required this.onSearch,
  }) : super(key: key);

  @override
  _CitySearchBarState createState() => _CitySearchBarState();
}

class _CitySearchBarState extends State<CitySearchBar> {
  bool _isSearching = false;
  final TextEditingController _controller = TextEditingController();

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) _controller.clear();
    });
  }

  void _submitSearch(String value) {
    if (value.trim().isNotEmpty) {
      widget.onSearch(value.trim());
      _toggleSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _isSearching
            ? Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                decoration: const InputDecoration(
                  hintText: 'Search city...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onSubmitted: _submitSearch,
              ),
            )
            : Text(
              widget.currentCity,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
        const Spacer(),
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          color: Colors.white,
          onPressed: _toggleSearch,
        ),
      ],
    );
  }
}
