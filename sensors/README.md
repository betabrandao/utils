# Simulador de sensores de temperatura usando o Faker

https://faker.readthedocs.io/en/master/

### Tecnologia

 Python 3.

### Sensores

- Temperatura
- Pressão
- PotenciaElétrica


### Payload to tópico de Métrica:

```python
Object {
timestamp: TimeStamp,
value: Double,
type: Enum(Count, Gauge, Histogram, Summary),
sensorType: Enum(Temperature, ),
MetaData: Object {
	MachineID: String,
	host: String,
	Severity: Enum(Critical, High, Medium, Low),
	MachineName: String,
	CmdbId: string,
	Key: Value
	},
tags: Object{
	orgName: String,
	BusinessUnit: String,
	ProjectName: String
	},
count: 1
}
```
