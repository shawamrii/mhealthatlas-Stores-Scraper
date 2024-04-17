# Logstash

*Logstash* provides functionalities for transforming and filtering of log message before the messages are stored in the elastic search database.

## Dependencies

This service depends on `elasticsearch`. The service is only functional, if the `elasticsearch` service is running.

## *Logstash* Folder Structure

The table below gives an overview of the subfolder structure of the *Logstash* folder.

| Folder | Short Description |
| ----   |     ----          |
| [pipeline](pipeline/) | contains the logstash pipeline configuration |
