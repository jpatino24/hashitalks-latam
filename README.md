# hashitalks-latam

## Arquitectura de despliegue

![](./images/hashitalks_demo.png)

El diagrama anterior es un detalle de los componentes que se despliegan en la nube de con el código contenido en este repositorio y sirven como demostración para comprender el funcionamiento de un flujo completo de aprovisionamiento usando IaC, CaC e infraestructura inmutable.

### Ejecución del Flujo de aprovisionamiento 

```bash
$ make create_pipeline
```

### Actualización Frontend

```bash
$ make update_frontend
```

### Destrucción del ambiente

```bash
$ make destroy_pipeline
```

