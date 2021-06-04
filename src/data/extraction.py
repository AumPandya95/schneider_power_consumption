from typing import Union

import numpy as np
import pandas as pd


def data_read(
        file_name: str,
) -> pd.DataFrame:
    """
    Read the given data file.
    :param file_name: str: name of the file to be read
    :return: pd.DataFrame: The dataframe structure of the file.
    """
    data = pd.read_csv(f"../../data/raw/{file_name}", sep=";")

    return data


def extract_data_for_site(
        site_id: str,
        data_file: Union[pd.DataFrame, np.array],
        column_name: str,
        filters: list = None
) -> pd.DataFrame:
    """
    Extract data for a given site_id.
    :param site_id: str: Name of the site_id which needs to be filtered
    :param data_file: pd.DataFrame: Data to be used for filtering
    :param column_name: str: The name of the column on which filtering is supposed to be performed
    :param filters: list: List of values which need to be filtered from data
    :return: pd.DataFrame: Filtered data frame
    """
    if filters:
        filtered_data = data_file[data_file[column_name].isin(filters)]
    else:
        filtered_data = data_file[data_file[column_name].str.startswith(site_id)]

    return filtered_data


def extract_data(
        site: str
) -> None:
    """
    Executor function to extract specific data sets.
    :param site: str: The specific site ID which needs to be filtered from the data
    :return: None: Saves the generated file into the data/processed folder
    """
    training_data = data_read("power-laws-detecting-anomalies-in-usage-training-data.csv")
    building_data = data_read("power-laws-detecting-anomalies-in-usage-metadata.csv")

    # Converting Timestamp column's data type to datetime
    training_data["Timestamp"] = pd.to_datetime(training_data["Timestamp"])
    training_data.sort_values(by="Timestamp", ascending=True, inplace=True)

    # Filtering data sets for the given site
    filtered_training_data = extract_data_for_site(data_file=training_data, site_id=site)


if __name__ == "__main__":
    import os
    print(os.getcwd())
    data_read("power-laws-detecting-anomalies-in-usage-training-data.csv")
