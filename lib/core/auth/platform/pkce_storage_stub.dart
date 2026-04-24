final _memory = <String, String>{};

void pkceWrite(String key, String value) => _memory[key] = value;

String? pkceRead(String key) => _memory[key];

void pkceDelete(String key) => _memory.remove(key);
