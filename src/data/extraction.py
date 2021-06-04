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
        data_file: Union[pd.DataFrame, np.array],
        site_id: str
) -> pd.DataFrame:
    """
    Extract data for a given site_id.
    :param data_file: str: Data to be used for filtering
    :param site_id: str: Name of the site_id which needs to be filtered
    :return: pd.DataFrame
    """


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


if __name__ == "__main__":
    import os
    print(os.getcwd())
    data_read("power-laws-detecting-anomalies-in-usage-training-data.csv")
