#include "lib/hello-time.h"
#include <ctime>
#include <iostream>

void print_localtime() {
  auto result = std::time(nullptr);
  std::cout << std::asctime(std::localtime(&result));
}
