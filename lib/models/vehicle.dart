class Vehicle {
  String imageUrl;
  String brand;
  String mode;
  String vin;
  String description;

  Vehicle({
    this.brand,
    this.description,
    this.imageUrl,
    this.mode,
    this.vin,
  });
}

final vins = [
  '1D4HR48N83F556450',
  '1J8GR48K47C557691',
  'JHMGE8H35DC021099',
  '1B4HS28Z8XF610065',
  '5FNYF3H42AB013801',
  '1VWCT7A34FC019340'
];

final List<Vehicle> vehicles = [
  Vehicle(
      imageUrl: 'assets/images/Mercedes-Benz-gls.png',
      brand: '奔驰',
      mode: 'GLS450',
      vin: '1D4HR48N83F556450',
      description: '跨越高山远洋 方识乾坤之大'),
  Vehicle(
      imageUrl: 'assets/images/BMW-X5-40i.png',
      brand: '宝马',
      mode: 'X5',
      vin: '1J8GR48K47C557691',
      description: '越峥嵘 越从容'),
  Vehicle(
      imageUrl: 'assets/images/Porsche-E-Cayenne.png',
      brand: '保时捷',
      mode: 'Cayenne2019',
      vin: 'JHMGE8H35DC021099',
      description: '无畏无极'),
  Vehicle(
      imageUrl: 'assets/images/Audi-Q7.png',
      brand: '奥迪',
      mode: 'Q7',
      vin: '1B4HS28Z8XF610065',
      description: '势为强者'),
  Vehicle(
      imageUrl: 'assets/images/Volvo-XC90.png',
      brand: '沃尔沃',
      mode: 'XC90',
      vin: '5FNYF3H42AB013801',
      description: '一路守护 成就未来'),
  Vehicle(
      imageUrl: 'assets/images/landrover-rangerover.png',
      brand: '路虎',
      mode: 'RangeRover2020',
      vin: '1VWCT7A34FC019340',
      description: '挑战极限 征服世界'),
];
